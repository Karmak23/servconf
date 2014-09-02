#!/bin/bash -e

#source ${SERVCONF_COMMON}


# purge the previous munin installation.
if [[ -e /etc/cron.d/munin-node ]]; then
    apt-get remove -qq --purge munin-node --yes --force-yes
    apt-get autoremove -qq --purge --yes --force-yes

    rm -f /etc/cron.d/munin-to-statsd
fi

VERSION_INSTALLED=`dpkg -l | grep collectd | awk '{print $3}' | sort -u | grep 5.3`

if [[ -z "${VERSION_INSTALLED}" ]]; then
    apt-add-repository -y ppa:optaros/collectd-5.3 || true
    apt-get update -qq --yes --force-yes
    apt-get install -qq collectd --yes --force-yes
fi

if [[ ${HOSTNAME} = "lafayette.licorn.org" ]]; then
    CARBON_HOST=10.0.3.111
else
    CARBON_HOST=37.187.135.222
fi

cat ${SERVCONF_PATH}/etc/collectd/collectd.conf.template \
    | sed -e "s/@@CARBON_HOST@@/${CARBON_HOST}/" > /etc/collectd/collectd.conf

service collectd restart || service collectd start
