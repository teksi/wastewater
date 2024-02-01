ARG QGIS_TEST_VERSION=latest
FROM  opengisch/qgis:${QGIS_TEST_VERSION}

# remove QGIS apt repo to avoid signing key issues
RUN add-apt-repository -r  https://qgis.org/ubuntu && \
    add-apt-repository -r  https://qgis.org/ubuntu-ltr

RUN apt-get update && \
    apt-get -y install openjdk-8-jre curl locales postgresql-client python3-geoalchemy2 \
    && rm -rf /var/lib/apt/lists/*

RUN printf '[postgres]\ndbname=postgres\nuser=postgres\n' >> /etc/postgresql-common/pg_service.conf
RUN printf '[pg_tww]\ndbname=tww\nuser=postgres\n' >> /etc/postgresql-common/pg_service.conf

# Some defaults
ENV POSTGRES_PASSWORD=postgres
# otherwise psycopg2 cannot connect
ENV PGSERVICEFILE=/etc/postgresql-common/pg_service.conf

ENV PGSERVICE=pg_tww


ENV LANG=C.UTF-8

WORKDIR /
