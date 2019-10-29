#!/bin/bash

sudo mkdir -p /data/horizon
sudo chown stellar:stellar /data/horizon

INIT_DB=/data/horizon/.init_db
if [[ ! -f $INIT_DB ]]; then
  DB_URL="postgresql://postgres:pgpassword@host.docker.internal:5641/postgres?sslmode=disable"
  psql $DB_URL -c "create role stellar with password 'pgpassword'"
  psql $DB_URL -c "alter role stellar login"
  psql $DB_URL -c "create database horizon"
  psql $DB_URL -c "alter database horizon owner to stellar"
  set -e
  stellar-horizon db init
  touch $INIT_DB
fi

exec stellar-horizon $@
