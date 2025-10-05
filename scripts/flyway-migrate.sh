#!/bin/bash

flyway_script_path=$(cd "$(dirname "${0}")" ; cd ../infrastructure/postgres ; pwd -P)

docker run \
  -v ${flyway_script_path}/migrations:/flyway/sql:ro \
  --network sql-playground_default \
  --rm flyway/flyway:9.1.4 \
  migrate -user=flyway -password=flyway_ps -connectRetries=10 \
  -url='jdbc:postgresql://movieidb:5432/moviedb' -locations=filesystem:/flyway/sql
