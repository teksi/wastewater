# requires buildkit (default from docker engine 23.0)

ARG POSTGIS_IMAGE=postgis/postgis:16-3.5-alpine

# arm builds are not available with 3.2
#FROM imresamu/postgis-arm64:14-3.2-alpine AS base-arm64
FROM "${POSTGIS_IMAGE}" AS base-arm64

FROM "${POSTGIS_IMAGE}" AS base-amd64

FROM base-$BUILDARCH as common

ARG AUTO_INIT=True
ARG RUN_TEST=False

# System deps (bc + exiftool for testing)
RUN apk add --no-cache python3 py3-pip py3-virtualenv postgresql-dev wget exiftool bc git

# Add source
ADD . /src
WORKDIR /src

# Python deps
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip install --upgrade pip
RUN pip install -r datamodel/requirements.txt
RUN if [ "${RUN_TEST}" = "True" ]; then pip install -r datamodel/requirements-test.txt; fi

# Configure the postgres connections
RUN mkdir -p /etc/postgresql-common && \
    printf '[postgres]\ndbname=postgres\nuser=postgres\n' >> /etc/postgresql-common/pg_service.conf && \
    printf '[pg_tww]\ndbname=tww\nuser=postgres\n' >> /etc/postgresql-common/pg_service.conf && \
    printf '[pg_tww_demo]\ndbname=tww_demo\nuser=postgres\n' >> /etc/postgresql-common/pg_service.conf

# Some defaults
ENV POSTGRES_PASSWORD=postgres
# otherwise psycopg cannot connect
ENV PGSERVICEFILE=/etc/postgresql-common/pg_service.conf

ENV PGSERVICE=pg_tww

ENV PYTEST_ADDOPTS="--color=yes"
