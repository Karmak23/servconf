#!/bin/bash -e

if [[ -n "${OPEN_PORTS_TCP}" ]]; then

    for PORT in ${OPEN_PORTS_TCP}
    do
        iptables -A INPUT -p tcp -m tcp -s 0.0.0.0 -d ${MAIN_IP} \
                --dport ${PORT} -j ACCEPT
    done
fi

if [[ -n "${OPEN_PORTS_UDP}" ]]; then

    for PORT in ${OPEN_PORTS_UDP}
    do
        iptables -A INPUT -p udp -s 0.0.0.0 -d ${MAIN_IP} \
                --dport ${PORT} -j ACCEPT
    done
fi
