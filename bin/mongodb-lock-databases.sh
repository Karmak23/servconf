#!/bin/bash -e

CONF="/home/groups/local_config/etc/mongodb-backup/`hostname`"

if [ -f ${CONF} ]; then
    . ${CONF}
else
    echo ">> No MongoDB backup configuration ${CONF}, aborting."
    exit 0
fi

# No need to lock each databases, fsyncLock() locks the entire mongod.
# cf. MongoDB documentation, as of 20130808.
#
#if [[ -z "${1}" ]]; then
#    DBS=`mongo --quiet --eval 'db.adminCommand("listDatabases").databases.forEach(function(d){print(d.name)});' | grep -vE '^(local|test)$' | xargs`
#else
#    DBS="$@"
#fi

echo "> ---------------------------------------------------- fsyncLock started `date`" >&2

LOCKED=`mongo --quiet --eval "printjson(db.currentOp().fsyncLock)"`

if [[ "$LOCKED" = "undefined" ]]; then
    mongo --quiet --eval "printjson(db.fsyncLock());"
else
    echo "WARNING: MongoD instance is already LOCKED (it shouldn't have been)!"
fi

echo "> ---------------------------------------------------- fsyncLock completed `date`" >&2
