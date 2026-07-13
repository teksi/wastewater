# Upgrading a TEKSI wastewater 2024.0.5 database

This guide is for administrators of a TEKSI wastewater database created with
[release 2024.0.5](https://github.com/teksi/wastewater/releases/tag/2024.0.5).
That release was published before the datamodel was tracked by the upgrade
tool [pum](https://github.com/opengisch/pum), so it cannot be upgraded
directly.

The migration tool provided here does everything for you. You give it a
backup (dump) of your database, and it produces an upgraded backup:

* your original database is **never touched** — everything happens inside a
  disposable container,
* your data, including your own value list entries and custom `usr_*`
  columns, is preserved,
* the result is upgraded to the **latest TEKSI wastewater version** and ready
  for future upgrades with pum,
* every object is counted before and after: the tool **aborts if any object
  would disappear** during the migration,
* at the end, a summary shows any remaining difference between your migrated
  database and a brand-new installation (normally: none).

## What you need

* Windows 10/11 with [Docker Desktop](https://www.docker.com/products/docker-desktop/)
  installed and running,
* the TEKSI wastewater source code:
  [download the ZIP](https://github.com/teksi/wastewater/archive/refs/heads/migration-2024-0-5.zip)
  and extract it, e.g. to `C:\teksi\wastewater`,
* a backup of your database, made with pgAdmin or with `pg_dump`, for example:

  ```powershell
  pg_dump -h myserver -U myuser -F custom -f C:\teksi\dumps\mydb.backup mydb
  ```

  Both custom-format (`.backup`) and plain SQL (`.sql`) dumps are supported.

All commands below are typed in **PowerShell**.

## Step 1 — Build the migration tool

```powershell
cd C:\teksi\wastewater
docker build --platform linux/amd64 -f datamodel\scripts\migration_2024\Dockerfile -t tww-migrator datamodel
```

This only needs to be done once (repeat it after updating the source code).

## Step 2 — Run the migration

Put your dump in a folder, e.g. `C:\teksi\dumps\mydb.backup`, then:

```powershell
docker run --rm --platform linux/amd64 -v C:\teksi\dumps:/data tww-migrator migrate mydb.backup
```

> **No dump at hand?** You can also point the tool directly at your database —
> see [Migrating directly between databases](#migrating-directly-between-databases)
> below.

The migration takes a few minutes. At the end you will find in `C:\teksi\dumps`:

| File | Content |
|---|---|
| `mydb_upgraded_2026.0.1.backup` | Your upgraded database, ready to restore. |
| `mydb_diff_vs_fresh_install.json` | Full comparison report against a fresh installation. |

The console ends with a summary like:

```text
Feature count check (tww_od, before vs after migration):
  116 tables, 152264 objects before, 152264 after (in tables common to both)
  Feature count check: OK, no object disappeared
...
Diff summary: migrated database vs fresh install of the latest version:
  Tables: OK
  Columns: OK
  Constraints: OK
  ...
  Total: 0 difference(s)
Migrated database matches a fresh install
```

If differences are listed, they usually correspond to customizations of your
database.

## Step 3 — Check the result (optional but recommended)

You can keep the migrated database running inside the container to inspect it
with QGIS or pgAdmin before restoring it anywhere:

```powershell
docker run --rm --platform linux/amd64 -e SERVE=1 -p 5433:5432 -v C:\teksi\dumps:/data tww-migrator migrate mydb.backup
```

When the message `Connect with: ...` appears, declare the connection as a
PostgreSQL service: create (or edit) the file
`%APPDATA%\postgresql\.pg_service.conf` and add:

```ini
[pg_tww]
host=localhost
port=5433
dbname=tww
user=postgres
```

No password is required (the temporary server accepts local connections in
`trust` mode) — leave the password field empty.

QGIS and pgAdmin can then connect using the service name `pg_tww` — this is
the service name used by the TEKSI wastewater QGIS project, so the project
opens directly on the migrated database. With psql:

```powershell
psql service=pg_tww
```

Press `Ctrl-C` in the PowerShell window to stop when you are done. Nothing is
lost: the upgraded backup file was already written.

## Step 4 — Restore the upgraded database

Restore the produced backup on your PostgreSQL server (PostgreSQL 16 or
newer, with PostGIS), for example:

```powershell
createdb -h myserver -U postgres tww
pg_restore -h myserver -U postgres --dbname tww C:\teksi\dumps\mydb_upgraded_2026.0.1.backup
```

Your database is now managed by pum: future TEKSI wastewater releases can be
applied simply with `pum upgrade`.

## Migrating directly between databases

Instead of working with dump files, the tool can read your database directly
and/or write the result directly to a **new** database on your server.

**Read directly from your database** — pass a connection instead of a file
name (the source database is only read, never modified):

```powershell
docker run --rm --platform linux/amd64 -e PGPASSWORD=secret -v C:\teksi\dumps:/data tww-migrator migrate "postgresql://myuser@host.docker.internal:5432/mydb"
```

**Write directly to a new database on your server** — add `-e OUTPUT_DB=...`
pointing to a database name that does **not exist yet** (the tool creates
it; it refuses to touch an existing database):

```powershell
docker run --rm --platform linux/amd64 -e PGPASSWORD=secret -e OUTPUT_DB="postgresql://myuser@host.docker.internal:5432/mydb_migrated" -v C:\teksi\dumps:/data tww-migrator migrate "postgresql://myuser@host.docker.internal:5432/mydb"
```

Notes:

* `host.docker.internal` is how the container reaches a PostgreSQL server
  running **on your own machine**; for a database server elsewhere on the
  network, use its hostname or IP address directly.
* `-e PGPASSWORD=secret` provides the password for both connections; you can
  also put it in the URI (`postgresql://myuser:secret@...`).
* The user needs `CREATEDB` privilege on the target server (and ideally
  `CREATEROLE`, so the `tww_*` roles can be created if missing).
* An upgraded dump file is still written to `C:\teksi\dumps` as a backup;
  add `-e OUTPUT_FORMAT=none` if you only want the direct database output.

## Options

Add these to the `docker run` command with `-e NAME=value`:

| Option | Default | Description |
|---|---|---|
| `SRID` | `2056` | Coordinate reference system of your data. |
| `OUTPUT_FORMAT` | `custom` | Format of the produced backup: `custom`, `plain` (readable SQL), `both` or `none`. |
| `OUTPUT_DB` | *(empty)* | Connection to a **new** database to create on your server and fill with the result. |
| `PGPASSWORD` | *(empty)* | Password for the source/target connections. |
| `SERVE` | `0` | `1` = keep the migrated database running for inspection (see step 3). |

Example with a plain SQL output:

```powershell
docker run --rm --platform linux/amd64 -e OUTPUT_FORMAT=both -v C:\teksi\dumps:/data tww-migrator migrate mydb.backup
```

## Troubleshooting

* **`docker: command not found` / cannot connect to Docker** — make sure
  Docker Desktop is started (whale icon in the system tray).
* **`input dump not found`** — the dump file must be inside the folder given
  to `-v ...:/data`, and you pass only its file name to the command, not the
  full path.
* **Port already in use (step 3)** — another PostgreSQL is using port 5433;
  choose another one, e.g. `-p 5440:5432`, and connect to that port instead.
* **`could not create database ... (does it already exist?)`** — `OUTPUT_DB`
  must point to a database that does not exist yet; drop it first or choose
  another name.
* **Cannot reach your database server** — from inside the container,
  `localhost` is the container itself; use `host.docker.internal` for a
  server running on your machine.
* The migration assumes the standard Swiss SRID **2056**. If your database
  uses another SRID, set `-e SRID=...` accordingly.

---

*For developers: the delta script applied by the tool is
[`delta_2024.0.5_to_2025.0.1.sql`](delta_2024.0.5_to_2025.0.1.sql); it is
built and verified reproducibly with the `build-delta` command of the image
against the canonical `tww_dev_structure_with_value_lists.sql` asset of the
2024.0.5 release (sha256-pinned in the [Dockerfile](Dockerfile)). The
`verify <dump>` command runs a migration and fails if the result differs
from a fresh installation. On macOS/Linux, the wrapper
[`migrate.sh`](migrate.sh) builds and runs the image in one step.*
