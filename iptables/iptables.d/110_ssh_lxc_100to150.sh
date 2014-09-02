#!/bin/bash -e

# ============================================================================= *.1flow.net

if [ -f /etc/default/lxc -a -z "${PHYSCONF_FIREWALL_DISABLE_LXC_100TO150}" ]; then

    # NOTE: IPs/ports only between 100 and 150 here. IPs/ports under 100 are
    # specific to some LXCs on only some physical hosts. Idem for ports > 150.

    for PORT in `seq 100 150`
    do
        iptables -t nat -A PREROUTING -i ${MAIN_IFACE} -p tcp -d ${MAIN_IP} --dport 22${PORT} \
            -j DNAT --to-destination 10.0.3.${PORT}:22
    done
fi
