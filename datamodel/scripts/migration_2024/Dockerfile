# Reusable migration image: TEKSI wastewater 2024.0.5 -> pum-managed latest
#
# Batch job semantics: give it a dump of a 2024.0.5 database, it restores it
# into an embedded PostGIS server, applies the delta to reach the 2025.0.1
# pum baseline, sets the baseline, upgrades to the latest changelog and dumps
# the upgraded database back out.
#
# Build (from the repository root):
#   docker build --platform linux/amd64 -f datamodel/scripts/migration_2024/Dockerfile -t tww-migrator datamodel
#
# Usage:
#   docker run --rm --platform linux/amd64 -v /path/to/dumps:/data tww-migrator migrate <input-dump>
#   docker run --rm --platform linux/amd64 tww-migrator migrate <source-connection-string>
#   docker run --rm --platform linux/amd64 -v /path/to/dumps:/data tww-migrator build-delta
#   docker run --rm --platform linux/amd64 -v /path/to/dumps:/data tww-migrator verify <input-dump>

FROM postgis/postgis:16-3.5

# Version of the released, pre-pum datamodel we migrate from.
ARG TWW_2024_VERSION=2024.0.5
# sha256 of the release asset tww_dev_structure_with_value_lists.sql (reproducibility pin).
ARG TWW_2024_STRUCTURE_SHA256=4a5be6bf624a3cead6a699838ab90719fa5988effbc72f24a5f7bce12edb10a6

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        postgresql-client-17 \
    && rm -rf /var/lib/apt/lists/*

# Python environment with pum. The base image (Debian bullseye) only ships
# Python 3.9, while the datamodel tooling requires >= 3.10: use uv to
# provision a managed CPython (seeded with pip so pum can install the
# datamodel dependencies itself).
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv
COPY requirements.txt /opt/tww/requirements.txt
RUN uv venv --seed --python 3.12 /opt/venv \
    && VIRTUAL_ENV=/opt/venv uv pip install --no-cache -r /opt/tww/requirements.txt
ENV PATH="/opt/venv/bin:${PATH}"

# Canonical 2024.0.5 structure + value lists (reference for delta building)
RUN curl -fsSL -o /opt/tww/tww_2024_structure_with_value_lists.sql \
        "https://github.com/teksi/wastewater/releases/download/${TWW_2024_VERSION}/tww_dev_structure_with_value_lists.sql" \
    && sha256sum /opt/tww/tww_2024_structure_with_value_lists.sql \
    && if [ -n "${TWW_2024_STRUCTURE_SHA256}" ]; then \
           echo "${TWW_2024_STRUCTURE_SHA256}  /opt/tww/tww_2024_structure_with_value_lists.sql" | sha256sum -c -; \
       else \
           echo "WARNING: TWW_2024_STRUCTURE_SHA256 not provided, asset not pinned"; \
       fi

# Datamodel (changelogs, pum config, app hooks)
COPY . /opt/tww/datamodel

# Migration scripts
COPY scripts/migration_2024/delta_2024.0.5_to_2025.0.1.sql /opt/tww/migration/delta_2024.0.5_to_2025.0.1.sql
COPY scripts/migration_2024/sync_vl.py /opt/tww/migration/sync_vl.py
COPY scripts/migration_2024/entrypoint.sh /usr/local/bin/tww-entrypoint.sh
RUN chmod +x /usr/local/bin/tww-entrypoint.sh

ENV TWW_2024_VERSION=${TWW_2024_VERSION}
# Parameters of the migration (overridable at run time)
ENV SRID=2056
# custom | plain | both | none
ENV OUTPUT_FORMAT=custom
# connection string/URI of a NEW database to create on an external server
# and fill with the migrated result (empty = disabled)
ENV OUTPUT_DB=
# 1 = keep PostgreSQL running after the command for inspection
ENV SERVE=0

VOLUME /data
WORKDIR /data

ENTRYPOINT ["/usr/local/bin/tww-entrypoint.sh"]
CMD ["migrate"]
