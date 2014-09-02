#!/bin/bash -e
#
# Starting from http://serverfault.com/a/136612/166356
# we have interesting implementations. As `curl` is not
# always installed, I prefer:
#       wget -qqO - http://myip.dnsomatic.com
#


if [ -e /etc/physconf/iptables/variables ]; then

	. /etc/physconf/iptables/variables

fi

echo -n "(IP: ${MAIN_IP}, open TCP: ${FRIENDS_PORTS}, open UDP: ${FRIENDS_PORTS_UDP}) "
