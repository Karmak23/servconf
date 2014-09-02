#!/bin/bash -e

#source ${GLOCONF_COMMON}

MACHINE_PATH="${GLOCONF_PATH}/private-data/machines/${HOSTNAME}"

if [[ -d "${MACHINE_PATH}" ]]; then (

    INSTALL_SOURCE=${GLOCONF_PATH}
    cd ${MACHINE_PATH}

    while read PATHNAME; do

        BASENAME=`basename ${PATHNAME}`
        PREINST=${GLOCONF_PATH}/install-scripts/pre-${BASENAME}.sh
        POSTINST=${GLOCONF_PATH}/install-scripts/post-${BASENAME}.sh

        if [[ -e ${PREINST} ]]; then
            echo "Executing pre-install script ${PREINST}…"
            bash -e ${PREINST}
        fi

        echo "Synching /${PATHNAME}…"

        if [[ -d /${PATHNAME} ]]; then
            FINAL=`dirname /${PATHNAME}`
        else
            FINAL=/${PATHNAME}
        fi

        # sync the manchine independant files if they exit.
        if [[ -e ${INSTALL_SOURCE}/${PATHNAME} ]]; then
            rsync -a ${INSTALL_SOURCE}/${PATHNAME} ${FINAL}
        fi

        # Then sync the specific files over the generic ones.
        if [[ -e ${INSTALL_SOURCE}/pirvate-data/${PATHNAME} ]]; then
            rsync -a ${INSTALL_SOURCE}/private-data/${PATHNAME} ${FINAL}
        fi

        if [[ -e ${POSTINST} ]]; then
            echo "Executing post-install script ${PREINST}…"
            bash -e ${POSTINST}
        fi

    done < install

); fi
