#!/bin/bash -e

#
# for new friends on port:25, update /etc/potfix/main.cf too.
#


# I can connect to myself via MAIN-IP, but only via interface lo.
#iptables -A INPUT -p tcp -m tcp -s ${MAIN_IP} -d ${MAIN_IP} -i lo -j ACCEPT

# Only my friends can connect to these service via my external
# interface. All other attempted connections are just dropped.
if [[ -n "${FRIENDS_PORTS_TCP}" ]]; then

    for PORT in ${FRIENDS_PORTS_TCP}
    do
    	for FRIEND in ${FRIENDS_IPS}
        do
            iptables -A INPUT -p tcp -m tcp -s ${FRIEND} -d ${MAIN_IP} \
                --dport ${PORT} -j ACCEPT
        done
    done
fi

if [[ -n "${FRIENDS_PORTS_UDP}" ]]; then

    for PORT in ${FRIENDS_PORTS_UDP}
    do
        for FRIEND in ${FRIENDS_IPS}
        do
            iptables -A INPUT -p udp -s ${FRIEND} -d ${MAIN_IP} \
                --dport ${PORT} -j ACCEPT
        done
    done
fi

# —————————————————————————————————————————————————— Complex friends
# Not all friends IPS on all friends ports,
# or specific destination(s) for specific ports,
# or mix of these.

if [[ -n "${FRIENDS_TCP_PARTIAL}" ]]; then

    for PORT in ${FRIENDS_TCP_PARTIAL}; do

        destination_temp_variable=FRIENDS_TCP_${PORT}_DST
        destnations=${!destination_temp_variable}
        source_temp_variable=FRIENDS_TCP_${PORT}_SRC
        sources=${!source_temp_variable}

        for destination in ${destnations}; do

            for source in ${sources}; do

                iptables -A INPUT -p tcp -m tcp \
                    -s ${source} -d ${destination} \
                    --dport ${PORT} -j ACCEPT

            done
        done
    done
fi

if [[ -n "${FRIENDS_UDP_PARTIAL}" ]]; then

    for PORT in ${FRIENDS_UDP_PARTIAL}; do

        destination_temp_variable=FRIENDS_UDP_${PORT}_DST
        destnations=${!destination_temp_variable}
        source_temp_variable=FRIENDS_UDP_${PORT}_SRC
        sources=${!source_temp_variable}

        for destination in ${destnations}; do

            for source in ${sources}; do

                iptables -A INPUT -p udp -s ${source} -d ${destination} \
                    --dport ${PORT} -j ACCEPT

            done
        done
    done
fi
