#!/bin/bash -e

#source ${SERVCONF_COMMON}

# MOVE eveything to /home, this is nearly the only dir we backup
for BLOCK in mongodb "postgresql;postgresql-server"
do (
    BLOCK_ARRAY=(${BLOCK//;/ })
    DIRECTORY=${BLOCK_ARRAY[0]}
    SERVICE=${BLOCK_ARRAY[1]}

    [[ -z "${SERVICE}" ]] && SERVICE=${DIRECTORY}

    cd /var/lib

    if [[ -e ${DIRECTORY} && ! -L ${DIRECTORY} ]]; then

        stop ${SERVICE} || service ${SERVICE} stop || true

        echo -n "MOVING /var/lib/${DIRECTORY} into home… "

        mv ${DIRECTORY} /home/
        ln -sf /home/${DIRECTORY} .

        echo "done."

        start ${SERVICE} || service ${SERVICE} start || true
    fi
); done
