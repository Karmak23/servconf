#!/bin/bash


source /etc/servconf.conf

# Could also be built from ${SERVCONF_PATH} but I find the later less
# prone to needing review when paths change in the source repository.
#IPTABLES_ROOT="/home/servconf/iptables"
IPTABLES_ROOT=`dirname $0`

FIREWALL_PATH="${MACHINE_PATH}/firewall"

MAIN_IFACE="eth0"
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

if [[ -n "${FIREWALL_OPEN}" ]]; then

	echo "Firewall is set to OPEN in configuration. You are naked, bro!"
	exit 0
fi

for script in ${IPTABLES_ROOT}/iptables.d/???_*.sh
do
	name=`basename ${script}`
	echo -n "Running ${name}… "
	. "${script}"
	echo "done."
done

