FROM python:3.12-alpine

ARG RUN_TESTS=False
ARG PUM_GH_SHA=""
ARG TEST_PACKAGES=""

# System deps (bc + exiftool for testing)
RUN apk add --no-cache python3 py3-pip py3-virtualenv postgresql-dev postgresql-client bash git ${TEST_PACKAGES}

# Add source
ADD . /usr/src
WORKDIR /usr/src

# Python deps
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip install --upgrade pip
RUN pip install -r datamodel/requirements.txt
RUN if [ "$(printf '%s' "${RUN_TESTS}" | tr '[:upper:]' '[:lower:]')" = "true" ]; then pip install -r datamodel/requirements-test.txt; fi
RUN if [ -n "${PUM_GH_SHA}" ]; then pip install "git+https://github.com/opengisch/pum.git@${PUM_GH_SHA}"; fi

# Configure the postgres connections
RUN mkdir -p /etc/postgresql-common && \
    printf "[postgres]\ndbname=postgres\nuser=postgres\n" >> /etc/postgresql-common/pg_service.conf

ENV PGSERVICEFILE=/etc/postgresql-common/pg_service.conf

ENV PYTEST_ADDOPTS="--color=yes"
