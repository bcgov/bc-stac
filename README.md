# bc-stac with stac-fastapi-pgstac 

<p align="center">
  <img src="https://user-images.githubusercontent.com/10407788/174893876-7a3b5b7a-95a5-48c4-9ff2-cc408f1b6af9.png" style="vertical-align: middle; max-width: 400px; max-height: 100px;" height=100 />
  <img src="https://fastapi.tiangolo.com/img/logo-margin/logo-teal.png" alt="FastAPI" style="vertical-align: middle; max-width: 400px; max-height: 100px;" width=200 />
</p>

## About stac-fastapi-pgstac
https://github.com/stac-utils/stac-fastapi-pgstac

[PgSTAC](https://github.com/stac-utils/pgstac) backend for [stac-fastapi](https://github.com/stac-utils/stac-fastapi), the [FastAPI](https://fastapi.tiangolo.com/) implementation of the [STAC API spec](https://github.com/radiantearth/stac-api-spec)


## Overview

**stac-fastapi-pgstac** is an HTTP interface built in FastAPI.
It validates requests and data sent to a [PgSTAC](https://github.com/stac-utils/pgstac) backend, and adds [links](https://github.com/radiantearth/stac-spec/blob/master/item-spec/item-spec.md#link-object) to the returned data.
All other processing and search is provided directly using PgSTAC procedural sql / plpgsql functions on the database.
PgSTAC stores all collection and item records as jsonb fields exactly as they come in allowing for any custom fields to be stored and retrieved transparently.

## `PgSTAC` version

`stac-fastapi-pgstac` depends on [`pgstac`](https://stac-utils.github.io/pgstac/pgstac/) database schema and [`pypgstac`](https://stac-utils.github.io/pgstac/pypgstac/) python package.

| stac-fastapi-pgstac Version  |     pgstac |
|                            --|          --|
|                          4.0 | >=0.8,<0.10 |
## Openshift
Postgres bitnami db can be deployed with helm charts/pgstac
```
helm upgrade --install charts/pgstac/
```
after deployment migrate to pgstac

```shell
# set up a venv if you haven't already
Python -m venv venv
Source venv/bin/activate
python -m pip install pypgstac[psycopg]

# set the enviroment -- you need to get the pguser and pgpassword from your openshift deployment
export PGHOST='127.0.0.1'
export PGPORT='5432'
export PGUSER='postres'
export PGDATABASE='bcstac'
export PGPASSWORD='quickpass'
pypgstac migrate
```

### Migrations - this needs to be done on database init

There is a Python utility as part of PgSTAC ([pypgstac](https://stac-utils.github.io/pgstac/pypgstac/)) that includes a migration utility.
To use:

```shell
# to get the name of the database pod use
# oc get pods
oc port-forward [pod name] 5432:5432
pypgstac migrate
```
### Bulk Loading

There is a Python utility for bulk load of STAC collections and items

```shell
pypgstac load collections test_data/stac_dem_collection.ndjson
pypgstac load collections test_data/stac_pc_collection.ndjson
pypgstac load items test_data/stac_dem_combined.ndjson
pypgstac load items test_data/stac_pc_combined.ndjson
```

# Docker testing
Debugging stac-fastapi-pgstac with docker (need to figure out networking to openshift)
? 
would this flag work  
--add-host=host.docker.internal:host-gateway

```shell
docker build -t bc-stac-api .
docker run \
    -p 8080:8080 \
    --name=bc-stac-api \
    --rm \
    --detach \
    --env-file=./.env \
    bc-stac-api
```
Debug from inside container
```shell
docker run -it --env-file=./.env bc-stac-api bash
uvicorn stac_fastapi.pgstac.app:app --host 127.0.0.1 --port 8080
```
