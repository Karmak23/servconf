#!/bin/bash -e

#source ${SERVCONF_COMMON}

for BINARY in `ls ${SERVCONF_PATH}/bin/*` `ls ${SERVCONF_PATH}/private-data/bin/*` `ls ${SERVCONF_PATH}/private-data/machines/${HOSTNAME}/bin/*`
do
    BASENAME=`basename ${BINARY}`
    rm -f /usr/local/bin/${BASENAME}
    ln -sf ${BINARY} /usr/local/bin/${BASENAME}
done
