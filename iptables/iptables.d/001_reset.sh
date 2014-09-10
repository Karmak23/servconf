#!/bin/bash -e

iptables -F
iptables -t nat -F

if `which arptables >/dev/null 2>&1`; then

	if [[ -z "${SERVCONF_FIREWALL_ARP_OPEN}" ]]; then
		#arptables -F
		#arptables -P INPUT DROP
		#arptables -P OUTPUT DROP
		#arptables -P FORWARD DROP
	fi
else
	echo "ARP tables is not installed, not touching ARP."
fi
