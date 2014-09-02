#!/bin/bash -e

# Restrict *everything*, not just TCP.
iptables -A INPUT -i ${MAIN_IFACE} -s 0.0.0.0/0 -d ${MAIN_IP} -j REJECT
