#!/bin/bash
set -e

./pg_ctl -D ./../data start
sleep 2

if ./psql -lqt | cut -d \| -f 1 | grep -qw postgres; then
    echo "Dropping existing postgres database"
    ./dropdb postgres
fi

./createdb postgres

./pg_ctl -D ./../data stop