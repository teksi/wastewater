# requires buildkit (default from docker engine 23.0)

ARG POSTGIS_IMAGE=postgis/postgis:16-3.5

# arm builds are not available with 3.2
#FROM imresamu/postgis-arm64:14-3.2 AS base-arm64
FROM "${POSTGIS_IMAGE}" AS base-arm64

FROM "${POSTGIS_IMAGE}" AS base-amd64

FROM base-$BUILDARCH as common

ARG AUTO_INIT=True
ARG RUN_TEST=False
ARG PSYCOPG_VERSION=3

# System deps (bc + exiftool for testing) and Python 3.11 from backports
RUN apt-get update && \
    apt-get install -y wget gnupg && \
    echo "deb http://deb.debian.org/debian bullseye-backports main" > /etc/apt/sources.list.d/backports.list && \
    apt-get update && \
    apt-get install -y python3.11 python3.11-venv python3.11-distutils python3-pip libpq-dev exiftool bc git && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 && \
    update-alternatives --install /usr/bin/pip3 pip3 /usr/bin/pip3 1 && \
    apt-get clean

# Add source
ADD . /src
WORKDIR /src

# Python deps
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip install git+https://github.com/opengisch/pirogue.git@v3
RUN pip install -r datamodel/requirements.txt
RUN if [ "${RUN_TEST}" = "True" ]; then pip install -r datamodel/requirements-test.txt; fi

# Configure the postgres connections
RUN printf '[postgres]\ndbname=postgres\nuser=postgres\n' >> /etc/postgresql-common/pg_service.conf
RUN printf '[pg_tww]\ndbname=tww\nuser=postgres\n' >> /etc/postgresql-common/pg_service.conf
RUN printf '[pg_tww_demo]\ndbname=tww_demo\nuser=postgres\n' >> /etc/postgresql-common/pg_service.conf


# Some defaults
ENV POSTGRES_PASSWORD=postgres
# otherwise psycopg cannot connect
ENV PGSERVICEFILE=/etc/postgresql-common/pg_service.conf

ENV PGSERVICE=pg_tww

ENV PYTEST_ADDOPTS="--color=yes"
