#!/usr/bin/env bash
#
# Entrypoint of the TWW migration image (2024.0.5 -> pum-managed latest).
#
# Commands:
#   migrate <source>       migrate the source, apply the delta to reach the
#                          2025.0.1 pum baseline, set the baseline, upgrade to
#                          the latest changelog and write the result out.
#                          <source> is either a dump file name in /data (pg_dump
#                          custom or plain SQL) or a connection string/URI to a
#                          database to migrate (the source DB is only read).
#   verify <source>        run 'migrate' then compare the migrated database
#                          against a fresh 'pum install' of the latest version.
#   build-delta            developer mode: restore the canonical 2024.0.5
#                          structure, install 2025.0.1 with pum, produce a
#                          'pum check' report in /data, apply the delta and
#                          re-check (exit 0 = delta is complete).
#
# Environment:
#   SRID           SRID of the datamodel (default 2056)
#   OUTPUT_FORMAT  custom | plain | both | none (default custom)
#   OUTPUT_DB      connection string/URI to a NEW database to create on an
#                  external server and fill with the migrated result
#   SERVE          1 = keep PostgreSQL running after the command so the
#                  migrated database can be inspected (publish port 5432)

set -Eeuo pipefail

DATAMODEL_DIR=/opt/tww/datamodel
DELTA_FILE=/opt/tww/migration/delta_2024.0.5_to_2025.0.1.sql
SYNC_VL=/opt/tww/migration/sync_vl.py
STRUCTURE_2024=/opt/tww/tww_2024_structure_with_value_lists.sql
BASELINE_VERSION=2025.0.1
# pg_dump matching the embedded server version, so the produced dumps restore
# on any server >= PG_MAJOR (the newest client tools are only used to *read*
# input dumps made with newer pg_dump versions).
PG_DUMP_SERVER=/usr/lib/postgresql/${PG_MAJOR}/bin/pg_dump
# newest client tools: used to talk to external servers, which may be newer
# than the embedded one
PG_BIN_NEWEST=$(ls -d /usr/lib/postgresql/*/bin | sort -V | tail -1)

export PGHOST=/var/run/postgresql
export PGUSER=postgres

log() {
    # stderr: unbuffered and consistent with pum's own logging
    echo "[tww-migrator] $(date -u '+%Y-%m-%dT%H:%M:%SZ') $*" >&2
}

conn() {
    # psycopg / pum connection string for a database on the embedded server
    echo "postgresql://postgres@/$1?host=/var/run/postgresql"
}

is_conninfo() {
    # connection string/URI vs plain file name
    [[ "$1" == postgresql://* || "$1" == postgres://* || "$1" == *=* ]]
}

conninfo_dbname() {
    # database name of a connection string/URI (for naming output files)
    python - "$1" <<'PYEOF'
import sys
from urllib.parse import urlsplit
arg = sys.argv[1]
if "://" in arg:
    print(urlsplit(arg).path.lstrip("/") or "db")
else:
    params = dict(p.split("=", 1) for p in arg.split() if "=" in p)
    print(params.get("dbname", "db"))
PYEOF
}

conninfo_maintenance() {
    # same server, but connected to the 'postgres' maintenance database
    python - "$1" <<'PYEOF'
import sys
from urllib.parse import urlsplit, urlunsplit
arg = sys.argv[1]
if "://" in arg:
    parts = urlsplit(arg)
    print(urlunsplit((parts.scheme, parts.netloc, "/postgres", parts.query, "")))
else:
    params = [p for p in arg.split() if not p.startswith("dbname=")]
    print(" ".join(params + ["dbname=postgres"]))
PYEOF
}

start_server() {
    log "Initializing embedded PostgreSQL cluster"
    mkdir -p "$PGDATA" /var/run/postgresql
    chown -R postgres:postgres "$PGDATA" /var/run/postgresql
    su -s /bin/bash postgres -c "initdb --auth=trust --no-instructions -D '$PGDATA'" > /dev/null
    su -s /bin/bash postgres -c "pg_ctl -D '$PGDATA' -w -t 60 -l /tmp/postgres.log start" > /dev/null
    log "PostgreSQL is up"
}

stop_server() {
    if [[ -f "$PGDATA/postmaster.pid" ]]; then
        su -s /bin/bash postgres -c "pg_ctl -D '$PGDATA' -w -m fast stop" > /dev/null || true
    fi
}

create_roles() {
    # Roles referenced by ownerships/ACLs in client dumps and managed by pum.
    for role in tww_viewer tww_user tww_manager tww_sysadmin; do
        psql -d postgres -v ON_ERROR_STOP=1 -c \
            "DO \$\$ BEGIN CREATE ROLE ${role} NOLOGIN; EXCEPTION WHEN duplicate_object THEN NULL; END \$\$;"
    done
}

restore_dump() {
    local db=$1
    local dump=$2
    if [[ ! -f "$dump" ]]; then
        log "ERROR: input dump not found: $dump"
        exit 2
    fi
    psql -d postgres -v ON_ERROR_STOP=1 -c "CREATE DATABASE ${db};"
    # Extensions required by the 2024.0.5 datamodel (uuid-ossp only for the
    # old uuid_generate_v4() column defaults, replaced by the delta).
    psql -d "${db}" -v ON_ERROR_STOP=1 \
        -c "CREATE EXTENSION IF NOT EXISTS postgis;" \
        -c "CREATE EXTENSION IF NOT EXISTS hstore;" \
        -c 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp";'
    if [[ "$(head -c 5 "$dump")" == "PGDMP" ]]; then
        log "Restoring $dump (pg_dump custom format) into database '${db}'"
        # Client dumps may cover a whole production database: restore only the
        # TWW data schemas, without ownership/ACLs of the source cluster.
        # tww_app / tww_app_pg2ili are not restored (recreated by pum).
        local schemas=(tww_od tww_vl tww_sys tww_cfg)
        local schema_args=()
        for s in "${schemas[@]}"; do
            # schema-filtered pg_restore does not emit CREATE SCHEMA
            psql -d "${db}" -v ON_ERROR_STOP=1 -q -c "CREATE SCHEMA IF NOT EXISTS ${s};"
            schema_args+=(-n "$s")
        done
        # use the newest pg_restore available: input dumps may come from a
        # newer pg_dump than the embedded server; emit SQL and filter out
        # settings unknown to the embedded server.
        local restore_sql=/tmp/restore.sql
        "$PG_BIN_NEWEST/pg_restore" --no-owner --no-acl "${schema_args[@]}" -f - "$dump" \
            | sed '/^SET transaction_timeout/d' > "$restore_sql"
        # The data schemas reference tww_app functions in column defaults and
        # triggers. Create stubs so the DDL restores; they are dropped with
        # the schema afterwards (and properly recreated by pum).
        log "Creating temporary tww_app function stubs"
        psql -d "${db}" -v ON_ERROR_STOP=1 -q -c "CREATE SCHEMA IF NOT EXISTS tww_app;" -c \
            "CREATE OR REPLACE FUNCTION tww_app.generate_oid(text, text) RETURNS text AS 'SELECT NULL::text' LANGUAGE sql;"
        grep -ohE 'EXECUTE (FUNCTION|PROCEDURE) tww_app\.[a-zA-Z0-9_]+' "$restore_sql" \
            | sed -E 's/EXECUTE (FUNCTION|PROCEDURE) tww_app\.//' | sort -u \
            | while read -r fn; do
                psql -d "${db}" -v ON_ERROR_STOP=1 -q -c \
                    "CREATE OR REPLACE FUNCTION tww_app.${fn}() RETURNS trigger AS 'BEGIN RETURN NEW; END' LANGUAGE plpgsql;"
            done
        psql -d "${db}" -v ON_ERROR_STOP=1 -q -f "$restore_sql"
        rm -f "$restore_sql"
    else
        log "Restoring $dump (plain SQL) into database '${db}'"
        psql -d "${db}" -v ON_ERROR_STOP=1 -q -f "$dump"
    fi
}

drop_app_schemas() {
    local db=$1
    log "Dropping app schemas (recreated by pum) in '${db}'"
    psql -d "${db}" -v ON_ERROR_STOP=1 \
        -c "DROP SCHEMA IF EXISTS tww_app CASCADE;" \
        -c "DROP SCHEMA IF EXISTS tww_app_pg2ili CASCADE;"
}

apply_delta() {
    local db=$1
    log "Applying delta 2024.0.5 -> ${BASELINE_VERSION} on '${db}'"
    psql -d "${db}" -v ON_ERROR_STOP=1 -q -f "$DELTA_FILE"
}

set_baseline() {
    local db=$1
    log "Setting pum baseline ${BASELINE_VERSION} on '${db}'"
    pum -p "$(conn "${db}")" -d "$DATAMODEL_DIR" baseline --create-table -b "$BASELINE_VERSION"
}

sync_value_lists() {
    # Upsert the tww_vl data of the target db from a reference db at the
    # baseline version (structure diff does not cover row contents).
    local target=$1
    local ref=$2
    log "Synchronizing tww_vl data of '${target}' from '${ref}'"
    python "$SYNC_VL" "$(conn "${ref}")" "$(conn "${target}")"
}

install_reference() {
    # Fresh pum install of the datamodel into a new database.
    local db=$1
    local max_version=${2:-}
    local extra=()
    if [[ -n "$max_version" ]]; then
        extra+=(--max-version "$max_version" --skip-create-app)
    fi
    log "Installing datamodel${max_version:+ (max version $max_version)} into '${db}'"
    psql -d postgres -v ON_ERROR_STOP=1 -c "CREATE DATABASE ${db};"
    pum -q -p "$(conn "${db}")" -d "$DATAMODEL_DIR" install \
        -p SRID "$SRID" "${extra[@]}"
}

pum_check() {
    local db1=$1
    local db2=$2
    local report=$3
    log "Comparing '${db1}' against '${db2}' (report: ${report})"
    # usr_% columns are the documented convention for client-specific
    # customizations and are not expected in the reference datamodel.
    pum -p "$(conn "${db1}")" -d "$DATAMODEL_DIR" check "$(conn "${db2}")" \
        -N public -N tww_app -N tww_app_pg2ili \
        -P 'usr_%' \
        -f json -o "$report"
}

print_diff_summary() {
    local report=$1
    python - "$report" <<'PYEOF'
import json, sys

with open(sys.argv[1]) as f:
    report = json.load(f)
total = 0
for check in report["check_results"]:
    diffs = check["differences"]
    if not diffs:
        print(f"  {check['name']}: OK")
        continue
    total += len(diffs)
    print(f"  {check['name']}: {len(diffs)} difference(s)")
    for diff in diffs[:50]:
        content = {
            k: (v[:120] + "..." if isinstance(v, str) and len(v) > 120 else v)
            for k, v in diff["content"].items()
            if v not in (None, "")
        }
        print(f"    [{diff['type']}] {content}")
    if len(diffs) > 50:
        print(f"    ... {len(diffs) - 50} more")
print(f"  Total: {total} difference(s)")
PYEOF
}

FINAL_CHECK_RC=0
final_check() {
    # Compare the migrated database against a fresh install of the latest
    # version and print a diff summary. Differences are reported, not fatal
    # (they may be intended client-specific drift).
    local name=$1
    install_reference tww_ref
    local report="/data/${name}_diff_vs_fresh_install.json"
    FINAL_CHECK_RC=0
    pum_check tww tww_ref "$report" || FINAL_CHECK_RC=$?
    log "Diff summary: migrated database vs fresh install of the latest version:"
    print_diff_summary "$report"
    if [[ $FINAL_CHECK_RC -eq 0 ]]; then
        log "Migrated database matches a fresh install"
    else
        log "Differences found; full report: ${report}"
    fi
}

output_to_db() {
    # Create a new database on an external server and fill it with the
    # migrated result. OUTPUT_DB is the connection to the new database.
    local dbname maint
    dbname=$(conninfo_dbname "$OUTPUT_DB")
    maint=$(conninfo_maintenance "$OUTPUT_DB")

    log "Creating database '${dbname}' on the target server"
    "$PG_BIN_NEWEST/psql" "$maint" -v ON_ERROR_STOP=1 -c "CREATE DATABASE \"${dbname}\";" || {
        log "ERROR: could not create database '${dbname}' (does it already exist?)"
        return 3
    }
    # best effort: TWW roles referenced by the grants of the migrated model
    for role in tww_viewer tww_user tww_manager tww_sysadmin; do
        "$PG_BIN_NEWEST/psql" "$maint" -q -c \
            "DO \$\$ BEGIN CREATE ROLE ${role} NOLOGIN; EXCEPTION WHEN duplicate_object THEN NULL; WHEN insufficient_privilege THEN RAISE WARNING 'cannot create role ${role}'; END \$\$;" \
            || log "WARNING: could not ensure role '${role}' on the target server"
    done

    log "Writing migrated database to '${dbname}' on the target server"
    # pg_restore >= 17 emits settings (e.g. transaction_timeout) that older
    # target servers reject: use the client matching the target server major
    # version when available (dump is made by pg_dump ${PG_MAJOR}).
    local target_major restore_bin
    target_major=$("$PG_BIN_NEWEST/psql" "$maint" -tA -c "SHOW server_version_num;" | cut -c1-2)
    if [[ -x "/usr/lib/postgresql/${target_major}/bin/pg_restore" ]]; then
        restore_bin="/usr/lib/postgresql/${target_major}/bin/pg_restore"
    elif [[ "$target_major" -gt "$PG_MAJOR" ]]; then
        restore_bin="$PG_BIN_NEWEST/pg_restore"
    else
        restore_bin="/usr/lib/postgresql/${PG_MAJOR}/bin/pg_restore"
    fi
    "$PG_DUMP_SERVER" --format=custom tww \
        | "$restore_bin" --no-owner --dbname="$OUTPUT_DB" --exit-on-error
    log "Migrated database written to the target server"
}

do_migrate() {
    local input=$1
    local name dump

    create_roles

    if is_conninfo "$input"; then
        name=$(conninfo_dbname "$input")
        dump="/tmp/source_${name}.backup"
        log "Dumping source database '${name}' (the source is only read)"
        "$PG_BIN_NEWEST/pg_dump" --format=custom --file="$dump" "$input"
    else
        name=$(basename "$input")
        name=${name%.*}
        dump="/data/${input}"
    fi

    restore_dump tww "$dump"
    drop_app_schemas tww
    apply_delta tww

    install_reference tww_baseline_ref "$BASELINE_VERSION"
    sync_value_lists tww tww_baseline_ref

    set_baseline tww

    log "Upgrading to latest changelog"
    pum -p "$(conn tww)" -d "$DATAMODEL_DIR" upgrade --skip-baseline-check -p SRID "$SRID"

    local version
    version=$(psql -d tww -tA -c \
        "SELECT version FROM tww_sys.pum_migrations ORDER BY version DESC, date_installed DESC LIMIT 1;")
    log "Database is now at version ${version}"

    if [[ "$OUTPUT_FORMAT" == "custom" || "$OUTPUT_FORMAT" == "both" ]]; then
        local out="/data/${name}_upgraded_${version}.backup"
        log "Dumping upgraded database to ${out}"
        "$PG_DUMP_SERVER" --format=custom --file="$out" tww
    fi
    if [[ "$OUTPUT_FORMAT" == "plain" || "$OUTPUT_FORMAT" == "both" ]]; then
        local out="/data/${name}_upgraded_${version}.sql"
        log "Dumping upgraded database to ${out}"
        "$PG_DUMP_SERVER" --format=plain --file="$out" tww
    fi
    if [[ -n "${OUTPUT_DB:-}" ]]; then
        output_to_db
    fi
    log "Migration finished successfully"

    final_check "$name"
}

do_verify() {
    if [[ $FINAL_CHECK_RC -eq 0 ]]; then
        log "VERIFY OK: migrated database matches a fresh install"
    else
        log "VERIFY FAILED: differences with a fresh install (this may be"
        log "intended client-specific drift, review the summary above)"
        return 1
    fi
}

do_build_delta() {
    create_roles

    log "Restoring canonical ${TWW_2024_VERSION} structure into 'tww_2024'"
    psql -d postgres -v ON_ERROR_STOP=1 -c "CREATE DATABASE tww_2024;"
    psql -d tww_2024 -v ON_ERROR_STOP=1 -q -f "$STRUCTURE_2024"
    drop_app_schemas tww_2024

    install_reference tww_2025 "$BASELINE_VERSION"

    local report=/data/check_2024_vs_2025_before_delta.json
    pum_check tww_2024 tww_2025 "$report" || true
    log "Pre-delta report written to ${report}"

    apply_delta tww_2024
    sync_value_lists tww_2024 tww_2025
    set_baseline tww_2024

    local report_after=/data/check_2024_vs_2025_after_delta.json
    if pum_check tww_2024 tww_2025 "$report_after"; then
        log "DELTA COMPLETE: no differences left"
    else
        log "DELTA INCOMPLETE: differences remain, see ${report_after}"
        return 1
    fi
}

maybe_serve() {
    [[ "${SERVE:-0}" == "1" ]] || return 0
    log "SERVE=1: keeping PostgreSQL running for inspection"
    psql -d postgres -v ON_ERROR_STOP=1 -q -c "ALTER SYSTEM SET listen_addresses TO '*';"
    {
        echo "host all all 0.0.0.0/0 trust"
        echo "host all all ::0/0 trust"
    } >> "$PGDATA/pg_hba.conf"
    su -s /bin/bash postgres -c "pg_ctl -D '$PGDATA' -w -l /tmp/postgres.log restart" > /dev/null
    log "Connect with: psql 'postgresql://postgres@localhost:<published-port>/tww'"
    log "Stop the container (Ctrl-C / docker stop) to end the session"
    trap 'trap - TERM INT EXIT; stop_server; exit 0' TERM INT
    while :; do
        sleep 3600 &
        wait $!
    done
}

main() {
    local command=${1:-migrate}
    shift || true

    start_server
    trap stop_server EXIT

    case "$command" in
        migrate)
            [[ $# -ge 1 ]] || { log "ERROR: usage: migrate <dump-file | connection-string>"; exit 2; }
            do_migrate "$1"
            maybe_serve
            ;;
        verify)
            [[ $# -ge 1 ]] || { log "ERROR: usage: verify <dump-file | connection-string>"; exit 2; }
            local rc=0
            do_migrate "$1"
            do_verify || rc=1
            maybe_serve
            exit "$rc"
            ;;
        build-delta)
            do_build_delta
            maybe_serve
            ;;
        *)
            log "ERROR: unknown command '$command' (expected: migrate | verify | build-delta)"
            exit 2
            ;;
    esac
}

main "$@"
