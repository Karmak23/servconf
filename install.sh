#!/bin/bash

USER=$1
HOSTNAME=`hostname`
SHORT_HOSTNAME=`hostname -s`

export SERVCONF_PATH=${PWD}
export SCRIPTS_BASE=${SERVCONF_PATH}/install-scripts
export SERVCONF_COMMON=${SCRIPTS_BASE}/common.sh
export HOST_INSTALL_FILE=${SERVCONF_PATH}/private-data/machines/${HOSTNAME}/install

PREINST_BASE=${SCRIPTS_BASE}/pre-install.d
POSTINST_BASE=${SCRIPTS_BASE}/post-install.d

source ${SERVCONF_COMMON}

source_config_dir ${PREINST_BASE}

source_config_dir ${POSTINST_BASE}
