#!/bin/bash

#IPTABLES_ROOT="/home/groups/local_config/iptables"
IPTABLES_ROOT=`dirname $0`

for script in ${IPTABLES_ROOT}/iptables.d/???_*.sh
do
	name=`basename ${script}`
	echo -n "Running ${name}… "
	. "${script}"
	echo "done."
done

