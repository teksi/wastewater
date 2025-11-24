# arm builds are not available with 3.2
#FROM imresamu/postgis-arm64:14-3.2-alpine AS base-arm64
FROM imresamu/postgis-arm64:16-3.5-alpine AS base-arm64

FROM postgis/postgis:16-3.5-alpine AS base-amd64

FROM base-$BUILDARCH AS common

ARG AUTO_INIT=True
ARG RUN_TEST=False
ARG PUM_GH_SHA=""
ARG DB_NAME=pum_test
ARG TEST_PACKAGES=""

# System deps (bc + exiftool for testing)
RUN apk add --no-cache python3 py3-pip py3-virtualenv postgresql-dev git ${TEST_PACKAGES}

# Add source
ADD . /usr/src
WORKDIR /usr/src

# Python deps
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip install --upgrade pip
RUN pip install -r datamodel/requirements.txt
RUN if [ "$(printf '%s' "${RUN_TEST}" | tr '[:upper:]' '[:lower:]')" = "true" ]; then pip install -r datamodel/requirements-test.txt; fi
RUN if [ -n "${PUM_GH_SHA}" ]; then pip install "git+https://github.com/opengisch/pum.git@${PUM_GH_SHA}"; fi

# Configure the postgres connections
RUN mkdir -p /etc/postgresql-common && \
    printf "[postgres]\ndbname=postgres\nuser=postgres\n" >> /etc/postgresql-common/pg_service.conf && \
    printf "[pg_${DB_NAME}]\ndbname=${DB_NAME}\nuser=postgres\n" >> /etc/postgresql-common/pg_service.conf && \
    printf "[pg_${DB_NAME}_demo]\ndbname=${DB_NAME}_demo\nuser=postgres\n" >> /etc/postgresql-common/pg_service.conf

# Some defaults
ENV POSTGRES_PASSWORD=postgres
# otherwise psycopg cannot connect
ENV PGSERVICEFILE=/etc/postgresql-common/pg_service.conf

ENV PGSERVICE=pg_${DB_NAME}

ENV PYTEST_ADDOPTS="--color=yes"
