#!/bin/bash -e

iptables -F
iptables -t nat -F

function maybe_stop_here() {
	if [[ -n "${FIREWALL_OPEN}" ]]; then

		echo "Firewall is OPEN in configuration. You are naked, bro!"
		exit 0
	fi
}

if `which arptables >/dev/null 2>&1`; then

		arptables -F

		maybe_stop_here

	if [[ -z "${SERVCONF_FIREWALL_ARP_OPEN}" ]]; then

		if [[ -n ${ARP_MANGLE_IPS} ]]; then
			for VIRTUAL_IP in ${ARP_MANGLE_IPS}; do
				arptables -A INPUT -d ${VIRTUAL_IP} -j DROP
				arptables -A OUTPUT -s ${VIRTUAL_IP} -j mangle --mangle-ip-s ${MAIN_IP}
			done
		fi
	fi
else
	echo "ARP tables is not installed, not touching ARP."

	maybe_stop_here
fi

