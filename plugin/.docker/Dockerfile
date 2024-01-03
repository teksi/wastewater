ARG QGIS_TEST_VERSION=latest
FROM  opengisch/qgis:${QGIS_TEST_VERSION}

# remove QGIS apt repo to avoid signing key issues
RUN add-apt-repository -r  https://qgis.org/ubuntu && \
    add-apt-repository -r  https://qgis.org/ubuntu-ltr

RUN apt-get update && \
    apt-get -y install openjdk-8-jre curl locales postgresql-client \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install geoalchemy2

ENV LANG=C.UTF-8

WORKDIR /
