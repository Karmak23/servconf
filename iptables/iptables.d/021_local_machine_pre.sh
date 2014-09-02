#!/bin/bash -e

script="/etc/physconf/iptables/pre"

if [ -e ${script} ]; then
	echo -n "Running custom ${script}… "
	. ${script}
	echo "done."
fi
