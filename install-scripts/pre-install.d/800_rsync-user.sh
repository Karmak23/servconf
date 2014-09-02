#!/bin/bash -e

if [[ -e /etc/default/rsync ]]; then
    echo -n "Creating rsync system user… "
    adduser --quiet --system rsync --force-badname --gecos "RSYNC daemon" \
        --disabled-password --disabled-login --ingroup nogroup
    echo "done."
fi
