#!/bin/bash

USER=$1

export SERVCONF_PATH=${PWD}
export HOSTNAME=`hostname`
export SHORT_HOSTNAME=`hostname -s`

export SCRIPTS_BASE=${SERVCONF_PATH}/install-scripts
export SERVCONF_COMMON=${SCRIPTS_BASE}/common.sh
export GROUP_PATH=${SERVCONF_PATH}/private-data
export MACHINE_PATH=${GROUP_PATH}/machines/${HOSTNAME}
export HOST_INSTALL_FILE=${MACHINE_PATH}/install

export PREINST_BASE=${SCRIPTS_BASE}/pre-install.d
export POSTINST_BASE=${SCRIPTS_BASE}/post-install.d

# Make these key variables accessible to standalone-running scripts.
cat <<EOF > /etc/servconf.conf
export SERVCONF_PATH=${SERVCONF_PATH}
export HOSTNAME=${HOSTNAME}
export SHORT_HOSTNAME=${SHORT_HOSTNAME}

export SCRIPTS_BASE=${SERVCONF_PATH}/install-scripts
export SERVCONF_COMMON=${SCRIPTS_BASE}/common.sh
export GROUP_PATH=${SERVCONF_PATH}/private-data
export MACHINE_PATH=${GROUP_PATH}/machines/${HOSTNAME}
export HOST_INSTALL_FILE=${MACHINE_PATH}/install

export PREINST_BASE=${SCRIPTS_BASE}/pre-install.d
export POSTINST_BASE=${SCRIPTS_BASE}/post-install.d
EOF


source ${SERVCONF_COMMON}

source_config_dir ${PREINST_BASE}

source_config_dir ${POSTINST_BASE}
