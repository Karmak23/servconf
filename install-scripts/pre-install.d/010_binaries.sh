#!/bin/bash -e

#source ${SERVCONF_COMMON}

for BINARY in `ls ${SERVCONF_PATH}/bin/* 2>/dev/null` `ls ${GROUP_PATH}/bin/* 2>/dev/null` `ls ${MACHINE_PATH}/bin/* 2>/dev/null`
do
    BASENAME=`basename ${BINARY}`
    rm -f /usr/local/bin/${BASENAME}
    ln -sf ${BINARY} /usr/local/bin/${BASENAME}
done
