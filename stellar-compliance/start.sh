#!/bin/bash

set -ex

sudo mkdir -p /data/compliance
sudo chown stellar:stellar /data/compliance

STELLAR_COMPLIANCE_CFG=/data/compliance/stellar-compliance.cfg
sudo cp -v /assets/stellar-compliance.cfg $STELLAR_COMPLIANCE_CFG
sudo chown stellar:stellar $STELLAR_COMPLIANCE_CFG

INIT_DB=/data/compliance/.init_db
if [[ ! -f $INIT_DB ]]; then
  DB_URL="postgresql://postgres:pgpassword@host.docker.internal:5641/postgres?sslmode=disable"

  # ignore errors in these commands since user or db might already be created
  psql $DB_URL -c "create role stellar with password 'pgpassword'" || :
  psql $DB_URL -c "alter role stellar login" || :
  psql $DB_URL -c "create database compliance" || :
  psql $DB_URL -c "alter database compliance owner to stellar" || :

  stellar-compliance --migrate-db --config $STELLAR_COMPLIANCE_CFG
  touch $INIT_DB
fi

exec stellar-compliance --config $STELLAR_COMPLIANCE_CFG
