#!/bin/bash

if ! `which iptables >/dev/null 2>&1`; then
	if [[ -n "${SERVCONF_DEBUG}" ]]; then
		echo "IPtables is not installed,aborting."
	fi

	exit 0
fi

source /etc/servconf.conf

# Could also be built from ${SERVCONF_PATH} but I find the later less
# prone to needing review when paths change in the source repository.
#IPTABLES_ROOT="/home/servconf/iptables"
IPTABLES_ROOT=`dirname $0`

FIREWALL_PATHS="${GROUP_PATH}/firewall ${MACHINE_PATH}/firewall"

MAIN_IFACE="eth0"

if ifconfig br0 >/dev/null 2>&1; then
	# we are on a physical host with a br0 interface.
	# Is most probably has failover IPs. But still
	# the private LXC network needs to go out. And this
	# is via br0, not eth0. (tested 20140911).
	LXC_MAIN_IFACE="br0"

else
	LXC_MAIN_IFACE="${MAIN_IFACE}"
fi

IP_CACHE="/var/cache/myip.txt"

if [ -f $IP_CACHE ]; then
    MAIN_IP=`cat $IP_CACHE`
else
    MAIN_IP=`wget -qqO - http://myip.dnsomatic.com`
    echo $MAIN_IP > $IP_CACHE
fi

#
# HEADS UP: we source the variables here to allow the admin to override
#  		    everything. This is dangerous, yet powerful and flexible.
#

for FIREWALL_PATH in ${FIREWALL_PATHS}; do
	if [[ -e ${FIREWALL_PATH}/variables ]]; then
		. ${FIREWALL_PATH}/variables
	fi
done

echo -n "(IP: ${MAIN_IP}, open friends TCP: ${FRIENDS_PORTS:-none}, open friends UDP: ${FRIENDS_PORTS_UDP:-none}, open TCP: ${OPEN_PORTS_TCP:-none}, open UDP: ${OPEN_PORTS_UDP:-none}) "

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
