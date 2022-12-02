#!/bin/bash

set -ex

if [ -z $2 ]
then
  echo Pass in the DB password followed by the keycloak password
  exit 1
fi

POD_NAME=keycloak-pod
DB_USER=keycloak
DB_PASSWORD=$1
KEYCLOAK_PASSWORD=$2
POSTGRES_DATA_DIR=$HOME/postgres-keycloak-data

mkdir $POSTGRES_DATA_DIR || true
podman stop postgres-keycloak keycloak || true
podman rm postgres-keycloak keycloak || true
podman pod stop $POD_NAME || true
podman pod rm $POD_NAME || true

podman pod create --name $POD_NAME -p 8443:8443

podman run -d \
        --pod $POD_NAME \
        --name postgres-keycloak \
        -e POSTGRES_USER=$DB_USER \
        -e POSTGRES_PASSWORD=$DB_PASSWORD \
        -e PGDATA=/var/lib/postgresql/data/pgdata \
        -e POSTGRES_DB=keycloak \
        -v $POSTGRES_DATA_DIR:/var/lib/postgresql/data:Z \
        docker.io/library/postgres:latest

podman build keycloak --build-arg DB_USER=$DB_USER --build-arg DB_PASSWORD=$DB_PASSWORD -t custom-keycloak

podman run -d \
        --pod $POD_NAME \
        --name keycloak \
        -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=$KEYCLOAK_PASSWORD \
        custom-keycloak \
        start --optimized

#podman run -d \
#        --pod $POD_NAME
#        --name keycloak -p 8080:8080 \
#        -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=change_me \
#        quay.io/keycloak/keycloak:latest \
#        start \
#        --db=postgres --features=token-exchange \
#        --db-url=localhost:5432 --db-username=$DB_USER --db-password=$DB_PASSWORD \
#        #--https-key-store-file=<file> --https-key-store-password=<password>
