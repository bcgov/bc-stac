ARG PYTHON_VERSION=3.12

FROM python:${PYTHON_VERSION}-slim AS base

# Any python libraries that require system libraries to be installed will likely
# need the following packages in order to build
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y build-essential git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

FROM base AS builder

WORKDIR /src

COPY . /src

RUN python -m pip install pypgstac[psycopg]

RUN chmod +x wait-for-it.sh

CMD ./wait-for-it.sh $APP_HOST:5432 -t 240 && sh migrate.sh