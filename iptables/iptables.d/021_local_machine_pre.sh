#!/bin/bash -e

script="${FIREWALL_PATH}/pre"

if [ -e ${script} ]; then
	echo -n "Running custom ${script}… "
	. ${script}
	echo "done."
fi
