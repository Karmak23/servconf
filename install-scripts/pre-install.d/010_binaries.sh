#!/bin/bash -e

#source ${GLOCONF_COMMON}

for BINARY in `ls ${GLOCONF_PATH}/bin/*`
do
    BASENAME=`basename ${BINARY}`
    rm -f /usr/local/bin/${BASENAME}
    ln -sf ${BINARY} /usr/local/bin/${BASENAME}
done
