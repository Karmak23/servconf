#!/bin/bash -e

#source ${SERVCONF_COMMON}

if ! has_line "iptables/run" "/etc/rc.local"; then
    install_message "INSTALL ${SERVCONF_PATH}/iptables/run.sh in /etc/rc.local"
fi

