#!/bin/bash -e

for BINARY in ${GLOCONF_PATH}/cron.daily/*
do
    BASENAME=`basename ${BINARY}`
    rm -f /etc/cron.daily/${BASENAME}
    ln -sf ${BINARY} /etc/cron.daily/${BASENAME}
done
