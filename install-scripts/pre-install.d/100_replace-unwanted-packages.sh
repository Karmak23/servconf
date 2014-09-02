#!/bin/bash -e

if [[ -x /usr/sbin/named ]]; then
    echo -n "Installing dnsmasq instead of bind9… "
    sudo apt-get remove -qq --purge --yes --force-yes bind9
    sudo apt-get install -qq --yes --force-yes dnsmasq
    sudo apt-get autoremove -qq --purge --yes --force-yes
    echo "done."
fi
