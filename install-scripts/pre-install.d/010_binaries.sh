#!/bin/bash -e

#source ${GLOCONF_COMMON}

for BINARY in `ls ${GLOCONF_PATH}/bin/*` `ls ${GLOCONF_PATH}/private-data/bin/*` `ls ${GLOCONF_PATH}/private-data/machines/${HOSTNAME}/bin/*`
do
    BASENAME=`basename ${BINARY}`
    rm -f /usr/local/bin/${BASENAME}
    ln -sf ${BINARY} /usr/local/bin/${BASENAME}
done
