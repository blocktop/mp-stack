#!/bin/bash

set -ex

sudo mkdir -p /data/federation
sudo chown stellar:stellar /data/federation

STELLAR_FEDERATION_CFG=/data/federation/stellar-bridge.cfg
sudo cp -v /assets/stellar-federation.cfg $STELLAR_FEDERATION_CFG
sudo chown stellar:stellar $STELLAR_FEDERATION_CFG

exec stellar-federation --conf $STELLAR_FEDERATION_CFG
