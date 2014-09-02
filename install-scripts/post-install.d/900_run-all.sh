#!/bin/bash -e

# newline after the 'running XXX_run-all.sh…'
echo

echo "----------------------------------------------------------- start Firewall"

sudo ${GLOCONF_PATH}/iptables/run.sh

echo "------------------------------------------------------------- end Firewall"
