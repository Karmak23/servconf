#!/bin/bash -e

SAVE="/home/groups/Sauvegardes/PostgreSQL"

mkdir -p $SAVE

chown -R postgres: /etc/postgresql $SAVE

service postgresql restart
