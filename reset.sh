#!/bin/sh

show_help() {
  echo "mp-stack reset script"
  echo "Use this script to start or rebuild the environment."
  echo "Usage: ./reset.sh [OPTIONS]"
  echo "  Options:"
  echo "    --no-rebuild   do not rebuild docker images"
  echo "    --volumes      delete and recreate volumes to rebuild databases"
}

log() {
  echo
  echo "*** $1"
}

wd=$(pwd)
bn=$(basename $wd)
if [ "$bn" != "mp-stack" ]; then
  log "must be run from the mp-stack directory"
  exit 1
fi

export MP_STACK_HOME=$wd

# parse options
volumes=false
rebuild=true
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
  --no-rebuild)
    rebuild=false
    shift
    ;;
  --volumes)
    volumes=true
    shift
    ;;
  *) # unknown option
    show_help
    exit 1
    ;;
  esac
done

# stop and delete all containers
log "stopping containers"
docker-compose stop

log "removing containers"
docker-compose rm -f

# delete and recreate volumes
if [ "$volumes" == "true" ]; then
  log "deleting and recreating volumes"
  docker volume rm data-volume
  docker volume create --name=data-volume
fi

# rebuild docker images
if [ "$rebuild" == "true" ]; then
  log "rebuilding images"
  docker build --tag stellar-base ./stellar-base
  docker-compose build
fi

# start the system

log "starting postgres container"
docker-compose up -d postgres

log "waiting for postgres to accept connections"
until pg_isready -h localhost -p 5641 >/dev/null; do
  sleep 1
done

log "starting stellar core"
docker-compose up -d stellar-core

log "waiting for stellar core to accept connections"
while ! nc -z localhost 11625 >/dev/null 2>/dev/null; do
  sleep 1
done
while ! nc -z localhost 11626 >/dev/null 2>/dev/null; do
  sleep 1
done

log "starting stellar horizon"
docker-compose up -d stellar-horizon

log "starting web auth server"
docker-compose up -d web-auth-server

log "starting transfer server"
docker-compose up -d transfer-server
