#!/bin/bash -e

#source ${SERVCONF_COMMON}

if ! has_line 'remotessh' '/etc/group'; then
    echo -n "Creating remotessh group and adding ${USER} to it… "
    addgroup --quiet --system remotessh
    adduser --quiet ${USER} remotessh
    echo "done."
fi

if [[ "${HOSTNAME}" != "`cat /etc/mailname`" ]]; then
    echo -n "Creating /etc/mailname with value ${HOSTNAME}… "
    echo ${HOSTNAME} > /etc/mailname
    echo "done."
fi
