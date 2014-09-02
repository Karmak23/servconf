#!/bin/bash -e

#source ${SERVCONF_COMMON}

if ! has_line "iptables/run" "/etc/rc.local"; then
	echo -n "Installing firewall…"

	if has_line "exit 0" /etc/rc.local; then
		sed -ie "s#^exit 0\$#${SERVCONF_PATH}/iptables/run.sh\nexit 0#" /etc/rc.local
	else
		echo "${SERVCONF_PATH}/iptables/run.sh" >> /etc/rc.local
	fi

	echo " done."
fi

