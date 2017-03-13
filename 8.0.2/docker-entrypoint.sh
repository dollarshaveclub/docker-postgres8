#!/bin/bash
set -e

./pg_ctl -D ./../data start


sleep 5


./createdb postgres

if [ "$POSTGRES_USER" = 'postgres' ]; then
	op='ALTER'
else
	op='CREATE'
fi

./psql --username postgres <<-EOSQL
	$op USER "$POSTGRES_USER" WITH CREATEDB PASSWORD '$POSTGRES_PASSWORD' ;
EOSQL

./createdb --owner $POSTGRES_USER $POSTGRES_DATABASE

./pg_ctl -D ./../data stop

./postmaster -D ./../data
