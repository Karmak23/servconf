#!/bin/bash -e

#source ${SERVCONF_COMMON}


# purge the previous munin installation.
if [[ -e /etc/cron.d/munin-node ]]; then
    apt-get remove -qq --purge munin-node --yes --force-yes
    apt-get autoremove -qq --purge --yes --force-yes

    rm -f /etc/cron.d/munin-to-statsd
fi

function install_collectd() {
    # TODO: move the installation/ppa block to sparks.
    VERSION_INSTALLED=`dpkg -l | grep collectd | awk '{print $3}' | sort -u | grep 5.3`

    if [[ -z "${VERSION_INSTALLED}" ]]; then
        apt-add-repository -y ppa:optaros/collectd-5.3 || true
        apt-get update -qq --yes --force-yes
        apt-get install -qq collectd --yes --force-yes
    fi
    # END TODO

    cat ${SERVCONF_PATH}/etc/collectd/collectd.conf.template \
        | sed -e "s/@@CARBON_HOST@@/${CARBON_HOST}/" > /etc/collectd/collectd.conf

    service collectd restart || service collectd start

}

if grep -E '^collectd$' ${MACHINE_DEINSTALL_FILE} >/dev/null 2>&1; then

    sudo apt-get remove -q --purge collectd --yes --force-yes || true

    sudo killall collectd || true
    sleep 1
    sudo killall collectdmon || true
    sleep 1
    sudo killall -9 collectd || true

else

    if [[ -e ${MACHINE_PATH}/collectd.templates.variables ]]; then

    	source ${MACHINE_PATH}/collectd.templates.variables
        install_collectd

    elif [[ -e ${GROUP_PATH}/collectd.templates.variables ]]; then

    	source ${GROUP_PATH}/collectd.templates.variables
        install_collectd
    fi

fi
