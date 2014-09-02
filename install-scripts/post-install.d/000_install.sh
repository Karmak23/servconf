#!/bin/bash -e

#source ${SERVCONF_COMMON}

GROUP_PATH="${SERVCONF_PATH}/private-data"
MACHINE_PATH="${SERVCONF_PATH}/private-data/machines/${HOSTNAME}"

if [[ -d "${MACHINE_PATH}" ]]; then (

    while read PATHNAME; do

        BASENAME=`basename ${PATHNAME}`
        SERVCONF_PREINST=${SERVCONF_PATH}/install-scripts/pre-${BASENAME}.sh
        SERVCONF_POSTINST=${SERVCONF_PATH}/install-scripts/post-${BASENAME}.sh
        GROUP_PREINST=${GROUP_PATH}/install-scripts/pre-${BASENAME}.sh
        GROUP_POSTINST=${GROUP_PATH}/install-scripts/post-${BASENAME}.sh
        MACHINE_PREINST=${MACHINE_PATH}/install-scripts/pre-${BASENAME}.sh
        MACHINE_POSTINST=${MACHINE_PATH}/install-scripts/post-${BASENAME}.sh

        for PREINST in ${SERVCONF_PREINST} ${GROUP_PREINST} ${MACHINE_PREINST}
        do
            if [[ -e ${PREINST} ]]; then
                echo "Executing pre-install script ${PREINST}…"
                bash -e ${PREINST}
            fi
        done

        echo "Synching /${PATHNAME}…"

        if [[ -d /${PATHNAME} ]]; then
            FINAL=`dirname /${PATHNAME}`
        else
            FINAL=/${PATHNAME}
        fi

        for SYNC_PATH in ${SERVCONF_PATH}/${PATHNAME} ${GROUP_PATH}/${PATHNAME} ${MACHINE_PATH}/${PATHNAME}
        do
            if [[ -e ${SYNC_PATH} ]]; then
                echo -n "Synching /${PATHNAME} with ${SYNC_PATH}…"
                rsync -a ${SYNC_PATH} ${FINAL}
                echo " done."
            fi
        done

        for POSTINST in ${SERVCONF_POSTINST} ${GROUP_POSTINST} ${MACHINE_POSTINST}
        do
            if [[ -e ${POSTINST} ]]; then
                echo "Executing post-install script ${POSTINST}…"
                bash -e ${POSTINST}
            fi
        done

    done < ${MACHINE_PATH}/install

); fi
