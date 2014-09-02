#!/bin/bash -e


function setup_rsync_defaults() {

    local FILE="/etc/default/rsync"

    # TODO: insert [ tab], it's currently a pain in my ST2.
    sed -ie "s/^#\? *RSYNC_ENABLE=.*/RSYNC_ENABLE=true/" $FILE
    sed -ie "s/^#\? *RSYNC_NICE=.*/RSYNC_NICE='19'/" $FILE
    sed -ie "s/^#\? *RSYNC_IONICE=.*/RSYNC_IONICE='-c3'/" $FILE
}


if has_line etc/rsyncd. ${GLOCONF_PATH}/machines/`hostname`/install; then

    mkdir -p /home/save
    chown -R rsync:admins /home/save
    chmod 775 /home/save

    chown root: /etc/rsyncd.conf

    setup_rsync_defaults

    service rsync restart || service rsync start

fi
