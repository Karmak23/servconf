#!/bin/bash -e
#
# http://doc.ubuntu-fr.org/iptables
# http://www.linuxhomenetworking.com/wiki/index.php/Quick_HOWTO_:_Ch14_:_Linux_Firewalls_Using_iptables
#

iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

iptables -A OUTPUT -p icmp -m conntrack \
	--ctstate NEW,ESTABLISHED,RELATED -j ACCEPT

iptables -A INPUT -p icmp -j ACCEPT

#iptables -A INPUT -p tcp -m tcp -i ${MAIN_IFACE} -s 0.0.0.0/0 \
#	-d ${MAIN_IP} --dport 22 -j ACCEPT
#iptables -A INPUT -p tcp -m tcp -i ${MAIN_IFACE} -s 0.0.0.0/0 \
#	-d ${MAIN_IP} --dport 80 -j ACCEPT
#iptables -A INPUT -p tcp -m tcp -i ${MAIN_IFACE} -s 0.0.0.0/0 \
#	-d ${MAIN_IP} --dport 443 -j ACCEPT


# We allow ALL destinations, to avoid locking fail-over IPs.
iptables -A INPUT -p tcp -m tcp -i ${MAIN_IFACE} -s 0.0.0.0/0 \
	-d 0.0.0.0/0 --dport 22 -j ACCEPT
iptables -A INPUT -p tcp -m tcp -i ${MAIN_IFACE} -s 0.0.0.0/0 \
	-d 0.0.0.0/0 --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -m tcp -i ${MAIN_IFACE} -s 0.0.0.0/0 \
	-d 0.0.0.0/0 --dport 443 -j ACCEPT
