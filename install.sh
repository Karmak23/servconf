#!/bin/bash

USER=$1
HOSTNAME=`hostname`
SHORT_HOSTNAME=`hostname -s`

export GLOCONF_PATH=${PWD}
export SCRIPTS_BASE=${GLOCONF_PATH}/install-scripts
export GLOCONF_COMMON=${SCRIPTS_BASE}/common.sh
export HOST_INSTALL_FILE=${GLOCONF_PATH}/private-data/machines/${HOSTNAME}/install

PREINST_BASE=${SCRIPTS_BASE}/pre-install.d
POSTINST_BASE=${SCRIPTS_BASE}/post-install.d

source ${GLOCONF_COMMON}

source_config_dir ${PREINST_BASE}

source_config_dir ${POSTINST_BASE}
