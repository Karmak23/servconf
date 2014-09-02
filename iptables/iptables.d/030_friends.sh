#!/bin/bash -e

#
# for new friends on port:25, update /etc/potfix/main.cf too.
#


# I can connect to myself via MAIN-IP, but only via interface lo.
#iptables -A INPUT -p tcp -m tcp -s ${MAIN_IP} -d ${MAIN_IP} -i lo -j ACCEPT

# Only my friends can connect to these service via my external
# interface. All other attempted connections are just dropped.
if [ -n "${FRIENDS_PORTS}" ]; then

    for PORT in ${FRIENDS_PORTS}
    do
    	for FRIEND in ${FRIENDS_IPS}
        do
            iptables -A INPUT -p tcp -m tcp -s ${FRIEND} -d ${MAIN_IP} --dport ${PORT} -j ACCEPT
        done
    done
fi

if [ -n "${FRIENDS_PORTS_UDP}" ]; then

    for PORT in ${FRIENDS_PORTS_UDP}
    do
        for FRIEND in ${FRIENDS_IPS}
        do
            iptables -A INPUT -p udp -s ${FRIEND} -d ${MAIN_IP} --dport ${PORT} -j ACCEPT
        done
    done
fi
