#!/bin/bash

#IPTABLES_ROOT="/home/servconf/iptables"
IPTABLES_ROOT=`dirname $0`

# keep in sync with ../install.sh
SERVCONF_PATH=`dirname ${IPTABLES_ROOT}`
export HOSTNAME=`hostname`
export SHORT_HOSTNAME=`hostname -s`

VARIABLES_FILE="${SERVCONF_PATH}/private-data/machines/${HOSTNAME}/firewall"

MAIN_IFACE="eth0"
HOSTNAME=`hostname`
SHORT_HOSTNAME=`hostname -s`
IP_CACHE="/var/cache/myip.txt"

if [ -f $IP_CACHE ]; then
    MAIN_IP=`cat $IP_CACHE`
else
    MAIN_IP=`wget -qqO - http://myip.dnsomatic.com`
    echo $MAIN_IP > $IP_CACHE
fi

if ! `which iptables >/dev/null 2>&1`; then
	if [[ -n "${SERVCONF_DEBUG}" ]]; then
		echo "IPtables is not installed,aborting."
	fi

	exit 0
fi

if [[ ${MAIN_IP} == 10.* || ${MAIN_IP} == 172.16.* || ${MAIN_IP} == 192.168.* ]]; then

	echo "NOT RUNNING the firewall on a private machine."
	exit 0
fi

for script in ${IPTABLES_ROOT}/iptables.d/???_*.sh
do
	name=`basename ${script}`
	echo -n "Running ${name}… "
	. "${script}"
	echo "done."
done

