#!/bin/bash

if [ -z "$1" ]; then
        echo "Usage: db.sh <dbname> <userid>"
fi

if [ -z "$2" ]; then
        echo "Usage: db.sh <dbname> <userid>"
fi

DBNAME=$1
USERID=$2
PGDUMP=/usr/bin/pg_dump
DUMPDIR=/opt/dbdump/

${PGDUMP} -o -O -x -U ${USERID} ${DBNAME} > ${DBNAME}.sql
