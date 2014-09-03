#!/bin/bash -e

#source ${SERVCONF_COMMON}

for BINARY in `ls ${SERVCONF_PATH}/bin/*` `ls ${GROUP_PATH}/bin/*` `ls ${MACHINE_PATH}/bin/*`
do
    BASENAME=`basename ${BINARY}`
    rm -f /usr/local/bin/${BASENAME}
    ln -sf ${BINARY} /usr/local/bin/${BASENAME}
done
