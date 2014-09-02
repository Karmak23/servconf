#!/bin/bash -e
#
# Starting from http://serverfault.com/a/136612/166356
# we have interesting implementations. As `curl` is not
# always installed, I prefer:
#       wget -qqO - http://myip.dnsomatic.com
#

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

if [ -e /etc/physconf/iptables/variables ]; then

	. /etc/physconf/iptables/variables

fi

echo -n "(IP: ${MAIN_IP}, open TCP: ${FRIENDS_PORTS}, open UDP: ${FRIENDS_PORTS_UDP}) "
