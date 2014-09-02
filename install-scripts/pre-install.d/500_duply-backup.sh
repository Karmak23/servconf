#!/bin/bash -e

#source ${GLOCONF_COMMON}

if [[ ! -L /etc/duply ]]; then
    ln -sf ${GLOCONF_PATH}/duply /etc/duply
fi

if [[ -e /etc/duply/`hostname` ]]; then
    ln -sf ${GLOCONF_PATH}/cron.daily/duply-backup /etc/cron.daily
fi
