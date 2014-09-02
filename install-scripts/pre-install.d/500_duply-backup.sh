#!/bin/bash -e

#source ${SERVCONF_COMMON}

if [[ ! -L /etc/duply ]]; then
    ln -sf ${SERVCONF_PATH}/duply /etc/duply
fi

if [[ -e /etc/duply/`hostname` ]]; then
    ln -sf ${SERVCONF_PATH}/cron.daily/duply-backup /etc/cron.daily
fi
