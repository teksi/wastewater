# requires buildkit (default from docker engine 23.0)

FROM imresamu/postgis-arm64:14-3.2 AS base-arm64

FROM postgis/postgis:14-3.2 AS base-amd64

FROM base-$BUILDARCH as common

ARG AUTO_INIT=True
ARG RUN_TEST=False

# System deps (bc + exiftool for testing)
RUN apt-get update && apt-get install -y python3 python3-pip python3-venv libpq-dev wget exiftool bc && apt-get clean

# Add source
ADD ./datamodel /src
WORKDIR /src

# Python deps
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip install -r requirements.txt
RUN if [ "${RUN_TEST}" = "True" ]; then pip install -r requirements-test.txt; fi


# Configure the postgres connections
RUN printf '[postgres]\ndbname=postgres\nuser=postgres\n' >> $(pg_config --sysconfdir)/pg_service.conf
RUN printf '[pg_teksi_wastewater]\ndbname=teksi_wastewater\nuser=postgres\n' >> $(pg_config --sysconfdir)/pg_service.conf
RUN printf '[pg_teksi_wastewater_demo]\ndbname=teksi_wastewater_demo\nuser=postgres\n' >> $(pg_config --sysconfdir)/pg_service.conf

RUN chmod +x /src/.docker/init_db.sh
ENV PATH="/src/.docker:${PATH}"

# Execute the main script on database initialization (zzz to be after postgis init)
RUN if [ "${AUTO_INIT}" = "True" ]; then ln -s /src/.docker/init_db.sh /docker-entrypoint-initdb.d/zzz_init_db.sh; fi

# Some defaults
ENV POSTGRES_PASSWORD=postgres
# otherwise psycopg2 cannot connect
ENV PGSERVICEFILE=/etc/postgresql-common/pg_service.conf

ENV PGSERVICE=pg_teksi_wastewater
