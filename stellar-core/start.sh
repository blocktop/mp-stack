#!/bin/bash

sudo mkdir -p /data/core
sudo chown stellar:stellar /data/core

INIT_DB=/data/core/.init_db
if [[ ! -f $INIT_DB ]]; then
  DB_URL="postgresql://postgres:pgpassword@host.docker.internal:5641/postgres?sslmode=disable"
  psql $DB_URL -c "create role stellar with password 'pgpassword'"
  psql $DB_URL -c "alter role stellar login"
  psql $DB_URL -c "create database stellar"
  psql $DB_URL -c "alter database stellar owner to stellar"
  set -e
  stellar-core new-db
  touch $INIT_DB
fi

set -e

# Ensure node seed has been generated
SEED=/data/core/seed
ADDRESS=/data/core/address
if [ ! -f $SEED ]; then
  out=`stellar-core gen-seed`
  out_clean=${out/\n/" "}
  echo -n $out_clean | cut -d" " -f 3 > $SEED
  echo -n $out_clean | cut -d" " -f 5 > $ADDRESS
fi

export NODE_SEED=`cat $SEED`
export NODE_ADDRESS=`cat $ADDRESS`

STELLAR_CORE_CFG=/data/core/stellar-core.cfg
sudo cp -v /stellar-core.cfg $STELLAR_CORE_CFG
sudo chown stellar:stellar $STELLAR_CORE_CFG
# Put node seed in cfg file
sed -i "s,NODE_SEED=,NODE_SEED=\"$NODE_SEED\",g" $STELLAR_CORE_CFG
sed -i "s,NODE_ADDRESS,$NODE_ADDRESS,g" $STELLAR_CORE_CFG

exec stellar-core --conf $STELLAR_CORE_CFG run
