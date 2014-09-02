#!/bin/bash -e

CONF="/home/groups/local_config/etc/mongodb-backup/`hostname`"

if [ -f ${CONF} ]; then
    . ${CONF}
else
    echo ">> No MongoDB backup configuration ${CONF}, aborting."
    exit 0
fi

echo "> -------------------------------------------------- fsyncUnlock started `date`" >&2

LOCKED=`mongo --quiet --eval "printjson(db.currentOp().fsyncLock)"`

if [[ "$LOCKED" = "true" ]]; then
    mongo --quiet --eval "printjson(db.fsyncUnlock());"
else
    echo "WARNING: MongoD is already NOT locked (it should have been)!"
fi

echo "> -------------------------------------------------- fsyncUnlock completed `date`" >&2
