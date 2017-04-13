#!/bin/bash
set -e

./pg_ctl -D ./../data start
sleep 2
./createlang plpgsql template1
./createdb postgres
./pg_ctl -D ./../data stop