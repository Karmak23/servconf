#!/bin/bash -e
#
# More on special NATs at:
# http://wl500g.info/showthread.php?3166-Loopback-with-iptables-port-forward-and-access-from-LAN-side
#

if [ -e /etc/default/lxc ]; then

	. /etc/default/lxc

	#iptables -t nat -A POSTROUTING -o ${MAIN_IFACE} -j MASQUERADE
    iptables -t nat -A POSTROUTING -o ${LXC_MAIN_IFACE} -s ${LXC_NETWORK} -j MASQUERADE
    #iptables -t nat -A POSTROUTING -o ${LXC_BRIDGE} -s ${MAIN_IP}     -j MASQUERADE

	# LXCs can connect to our public IP, only via the bridge, though
	#iptables -A INPUT -p tcp -m tcp -i ${LXC_BRIDGE} -s ${LXC_NETWORK} -d ${MAIN_IP} -j ACCEPT

	# LXCs can connect to anything
	iptables -A INPUT -i ${LXC_BRIDGE} -s ${LXC_NETWORK} -d 0.0.0.0/0 -j ACCEPT

    # NO need too, does nothing more.
    #iptables -A INPUT -p tcp -m tcp -i ${LXC_BRIDGE} -s ${MAIN_IP} -d ${LXC_NETWORK} -j ACCEPT
fi
