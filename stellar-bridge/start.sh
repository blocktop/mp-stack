#!/bin/bash

set -ex

sudo mkdir -p /data/bridge
sudo chown stellar:stellar /data/bridge

STELLAR_BRIDGE_CFG=/data/bridge/stellar-bridge.cfg
sudo cp -v /assets/stellar-bridge.cfg $STELLAR_BRIDGE_CFG
sudo chown stellar:stellar $STELLAR_BRIDGE_CFG

INIT_DB=/data/bridge/.init_db
if [[ ! -f $INIT_DB ]]; then
  DB_URL="postgresql://postgres:pgpassword@host.docker.internal:5641/postgres?sslmode=disable"

  # ignore errors in these commands since user or db might already be created
  psql $DB_URL -c "create role stellar with password 'pgpassword'" || :
  psql $DB_URL -c "alter role stellar login" || :
  psql $DB_URL -c "create database bridge" || :
  psql $DB_URL -c "alter database bridge owner to stellar" || :

  stellar-bridge --migrate-db --config $STELLAR_BRIDGE_CFG
  touch $INIT_DB
fi

exec stellar-bridge --config $STELLAR_BRIDGE_CFG
