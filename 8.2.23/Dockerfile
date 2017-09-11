FROM ubuntu:16.04
WORKDIR /usr/local/postgres-install

RUN apt-get update && apt-get -y upgrade && apt-get -y install build-essential libreadline6 libreadline6-dev zlib1g-dev vim gcc-4.7

ADD https://ftp.postgresql.org/pub/source/v8.2.23/postgresql-8.2.23.tar.gz /usr/local/postgres-install/postgresql-8.2.23.tar.gz

RUN gunzip postgresql-8.2.23.tar.gz && tar xf postgresql-8.2.23.tar

WORKDIR /usr/local/postgres-install/postgresql-8.2.23

RUN ./configure CC='gcc-4.7 -m64' && make && make install && adduser postgres && mkdir /usr/local/pgsql/data && chown postgres /usr/local/pgsql/data

COPY ./docker-entrypoint.sh /usr/local/bin/
COPY ./db-setup.sh /usr/local/pgsql/bin
RUN chmod +x /usr/local/pgsql/bin/db-setup.sh && chown postgres /usr/local/pgsql/bin/db-setup.sh

USER postgres
WORKDIR /usr/local/pgsql/bin

RUN ./initdb -D ./../data

COPY ./postgresql.conf /usr/local/pgsql/data
COPY ./pg_hba.conf /usr/local/pgsql/data

RUN ./db-setup.sh

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["./postmaster", "-D", "./../data"]