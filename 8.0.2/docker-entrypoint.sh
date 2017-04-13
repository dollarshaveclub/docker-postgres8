#!/bin/bash
set -e

./pg_ctl -D ./../data start

sleep 2

if [ "$POSTGRES_USER" = 'postgres' ]; then
	./psql --username postgres <<-EOSQL
	ALTER USER "$POSTGRES_USER" WITH CREATEDB PASSWORD '$POSTGRES_PASSWORD' ;
EOSQL
else
    ./psql --username postgres <<-EOSQL
CREATE OR REPLACE FUNCTION create_user_if_not_exists(username varchar, userpassword varchar) RETURNS integer AS \$body\$
BEGIN
   IF NOT EXISTS (
      SELECT *
      FROM   pg_catalog.pg_user
      WHERE  usename = username) THEN
        EXECUTE 'CREATE USER '
            || quote_ident(username)
            || ' WITH CREATEDB PASSWORD '
            || quote_literal(userpassword);
   END IF;

   RETURN 1;
END
\$body\$ LANGUAGE plpgsql;

select create_user_if_not_exists('$POSTGRES_USER', '$POSTGRES_PASSWORD');
EOSQL
fi

if ./psql -lqt | cut -d \| -f 1 | grep -qw "$POSTGRES_DATABASE"; then
    echo "$POSTGRES_DATABASE already exists"
else
    ./createdb --owner $POSTGRES_USER $POSTGRES_DATABASE
fi

./pg_ctl -D ./../data stop

echo "$@"

exec "$@"