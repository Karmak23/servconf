#!/bin/bash -e

#source ${GLOCONF_COMMON}

PHYSCONF_PATH=${GLOCONF_PATH}
GROUP_PATH="${GLOCONF_PATH}/private-data"
MACHINE_PATH="${GLOCONF_PATH}/private-data/machines/${HOSTNAME}"

if [[ -d "${MACHINE_PATH}" ]]; then (

    while read PATHNAME; do

        BASENAME=`basename ${PATHNAME}`
        PHYSCONF_PREINST=${GLOCONF_PATH}/install-scripts/pre-${BASENAME}.sh
        PHYSCONF_POSTINST=${GLOCONF_PATH}/install-scripts/post-${BASENAME}.sh
        GROUP_PREINST=${GROUP_PATH}/install-scripts/pre-${BASENAME}.sh
        GROUP_POSTINST=${GROUP_PATH}/install-scripts/post-${BASENAME}.sh
        MACHINE_PREINST=${MACHINE_PATH}/install-scripts/pre-${BASENAME}.sh
        MACHINE_POSTINST=${MACHINE_PATH}/install-scripts/post-${BASENAME}.sh

        for PREINST in ${PHYSCONF_PREINST} ${GROUP_PREINST} ${MACHINE_PREINST}
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

        for SYNC_PATH in ${PHYSCONF_PATH}/${PATHNAME} ${GROUP_PATH}/${PATHNAME} ${MACHINE_PATH}/${PATHNAME}
        do
            if [[ -e ${SYNC_PATH} ]]; then
                echo -n "Synching /${PATHNAME} with ${SYNC_PATH}…"
                rsync -a ${PHYSCONF_PATH}/${PATHNAME} ${FINAL}
                echo " done."
            fi
        done

        for POSTINST in ${PHYSCONF_POSTINST} ${GROUP_POSTINST} ${MACHINE_POSTINST}
        do
            if [[ -e ${POSTINST} ]]; then
                echo "Executing post-install script ${POSTINST}…"
                bash -e ${POSTINST}
            fi
        done

    done < ${MACHINE_PATH}/install

); fi
