#!/bin/bash -e

#source ${GLOCONF_COMMON}

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

# MOVE eveything to /home, this is nearly the only dir we backup
for DIRECTORY in mongodb postgresql
do (
    cd /var/lib
    if [[ ! -L ${DIRECTORY} ]]; then
        echo -n "MOVING /var/lib/${DIRECTORY} into home… "

        # XXX stop/start

        mv ${DIRECTORY} /home/
        ln -sf /home/${DIRECTORY} .

        echo "done."
    fi
); done
