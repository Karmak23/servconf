#!/bin/bash -e

#source ${GLOCONF_COMMON}

if [[ -x /usr/bin/lxc ]]; then

    if [[ -d /home/data ]]; then

        mkdir -p /home/data/lxc

        if [[ ! -L /home/lxc ]]; then
            ln -sf /home/data/lxc /home/lxc
        fi

    else
        mkdir -p /home/lxc
    fi

    if [[ ! -L /var/lib/lxc ]]; then
        mv /var/lib/lxc /home/lxc/data
        ln -sf /home/lxc/data /var/lib/lxc
    fi

    if [[ ! -L /var/cache/lxc ]]; then
        mv /var/cache/lxc /home/lxc/cache || mkdir /home/lxc/cache
        ln -sf /home/lxc/cache /var/cache/lxc
    fi

    if [[ ! -e /home/lxc/lxc-ubuntu-template+packages ]]; then
        ln -sf ${GLOCONF_PATH}/etc/lxc/lxc-ubuntu-template+packages /home/lxc/
    fi

fi

# Be sure the host nginx can walk into LXC's root,
# eg. to serve Django's static data from inside a LXC.
chmod u+rwx,g+rwx,o+rx-w /home/lxc /home/lxc/data /home/lxc/data/* /home/lxc/data/*/rootfs