# requires buildkit (default from docker engine 23.0)

# arm builds are not available with 3.2
#FROM imresamu/postgis-arm64:14-3.2 AS base-arm64
FROM postgis/postgis:14-3.2 AS base-arm64

FROM postgis/postgis:14-3.2 AS base-amd64

FROM base-$BUILDARCH as common

ARG AUTO_INIT=True
ARG RUN_TEST=False

# System deps (bc + exiftool for testing)
RUN apt-get update && apt-get install -y python3 python3-pip python3-venv libpq-dev wget exiftool bc && apt-get clean

# Add source
ADD . /src
WORKDIR /src

# Python deps
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip install -r datamodel/requirements.txt
RUN if [ "${RUN_TEST}" = "True" ]; then pip install -r datamodel/requirements-test.txt; fi


# Configure the postgres connections
RUN printf '[postgres]\ndbname=postgres\nuser=postgres\n' >> /etc/postgresql-common/pg_service.conf
RUN printf '[pg_tww]\ndbname=tww\nuser=postgres\n' >> /etc/postgresql-common/pg_service.conf
RUN printf '[pg_tww_demo]\ndbname=tww_demo\nuser=postgres\n' >> /etc/postgresql-common/pg_service.conf

RUN chmod +x /src/datamodel/.docker/init_db.sh
ENV PATH="/src/datamodel/.docker:${PATH}"

# Execute the main script on database initialization (zzz to be after postgis init)
RUN if [ "${AUTO_INIT}" = "True" ]; then ln -s /src/datamodel/.docker/init_db.sh /docker-entrypoint-initdb.d/zzz_init_db.sh; fi

# Some defaults
ENV POSTGRES_PASSWORD=postgres
# otherwise psycopg2 cannot connect
ENV PGSERVICEFILE=/etc/postgresql-common/pg_service.conf

ENV PGSERVICE=pg_tww

ENV PYTEST_ADDOPTS="--color=yes"
