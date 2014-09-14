#!/bin/bash -e

# Restrict *everything*, not just TCP.
#iptables -A INPUT -i ${MAIN_IFACE} -s 0.0.0.0/0 -d ${MAIN_IP} -j REJECT
iptables -A INPUT -i ${MAIN_IFACE} -s 0.0.0.0/0 -d 0.0.0.0/0 -j REJECT


if [[ -e /etc/fail2ban/fail2ban.conf ]]; then
	service fail2ban restart >/dev/null || true
fi
