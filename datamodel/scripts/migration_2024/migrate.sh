#!/usr/bin/env bash
#
# Convenience wrapper: build the migration image and run it on a dump.
#
# Usage:
#   ./migrate.sh <command> [args...]
#
#   ./migrate.sh migrate /path/to/dump.backup
#   ./migrate.sh migrate 'postgresql://user:pass@host:5432/sourcedb'
#   ./migrate.sh verify /path/to/dump.backup
#   ./migrate.sh build-delta [/path/to/output-dir]
#
# Environment:
#   SRID, OUTPUT_FORMAT   passed to the container (see entrypoint.sh)
#   OUTPUT_DB             connection string/URI to a NEW database to create
#                         and fill with the result (use host.docker.internal
#                         to reach a server running on this machine)
#   PGPASSWORD            password used for source/target connections
#   SERVE, SERVE_PORT     keep the migrated DB running for inspection
#   DATA_DIR              reports/dumps directory when the source is a
#                         connection string (default: current directory)
#
# The upgraded dump and reports are written next to the input dump
# (or into DATA_DIR / the given output directory).

set -Eeuo pipefail

REPO_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)
IMAGE=tww-migrator
PLATFORM=linux/amd64

command=${1:-}
[[ -n "$command" ]] || { echo "usage: $0 <migrate|verify|build-delta> [args...]"; exit 2; }
shift

docker build --platform "$PLATFORM" \
    -f "$REPO_ROOT/datamodel/scripts/migration_2024/Dockerfile" \
    -t "$IMAGE" "$REPO_ROOT/datamodel"

case "$command" in
    migrate|verify)
        input=${1:-}
        [[ -n "$input" ]] || { echo "ERROR: missing source (dump file or connection string)"; exit 2; }
        if [[ "$input" == postgresql://* || "$input" == postgres://* || "$input" == *=* ]]; then
            # source is a database connection; /data only receives reports/dumps
            data_dir=$(cd "${DATA_DIR:-.}" && pwd)
            arg="$input"
        else
            [[ -f "$input" ]] || { echo "ERROR: input dump not found: $input"; exit 2; }
            data_dir=$(cd "$(dirname "$input")" && pwd)
            arg=$(basename "$input")
        fi
        serve_args=()
        if [[ "${SERVE:-0}" == "1" ]]; then
            serve_args=(-e SERVE -p "${SERVE_PORT:-5433}:5432")
            echo "SERVE=1: after the migration, connect with:"
            echo "  psql 'postgresql://postgres@localhost:${SERVE_PORT:-5433}/tww'"
        fi
        docker run --rm --platform "$PLATFORM" \
            -e SRID -e OUTPUT_FORMAT -e OUTPUT_DB -e PGPASSWORD \
            --add-host=host.docker.internal:host-gateway \
            "${serve_args[@]}" \
            -v "$data_dir":/data \
            "$IMAGE" "$command" "$arg"
        ;;
    build-delta)
        data_dir=$(cd "${1:-.}" && pwd)
        docker run --rm --platform "$PLATFORM" \
            -e SRID \
            -v "$data_dir":/data \
            "$IMAGE" build-delta
        ;;
    *)
        echo "ERROR: unknown command '$command' (expected: migrate | verify | build-delta)"
        exit 2
        ;;
esac
