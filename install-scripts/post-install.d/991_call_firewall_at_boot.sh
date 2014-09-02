#!/bin/bash -e

#source ${GLOCONF_COMMON}

if ! has_line "iptables/run" "/etc/rc.local"; then
    install_message "INSTALL ${GLOCONF_PATH}/iptables/run.sh in /etc/rc.local"
fi

