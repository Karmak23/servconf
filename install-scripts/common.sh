#!/bin/bash -e

function has_line() {
    LINE=$1
    FILE=$2

    if grep -q "${LINE}" "${FILE}" >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

function install_message() {
    echo -e "\n>\n> ${1}\n>\n"
}


function source_config_dir() {

   CONFIG_DIR_ROOT=${1}
   QUIET=${2}

    for SCRIPT in ${CONFIG_DIR_ROOT}/???_*.sh
    do
        NAME=`basename ${SCRIPT}`

        if [[ -z "${QUIET}" ]]; then echo -n "Running ${NAME}… " ; fi

        . ${SCRIPT}

        if [[ -z "${QUIET}" ]]; then echo "done." ; fi

    done
}

# 'QUIET' could be anything: if $2 is not empty, the sourced names won't be displayed.
source_config_dir ${SERVCONF_PATH}/install-scripts/common.d QUIET
