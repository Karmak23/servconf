#!/bin/bash -e

USER=mms-agent
LOGS=/var/log/mms

adduser --quiet --system --disabled-password ${USER}

mkdir -p ${LOGS}

chown -R ${USER}: ${LOGS} /home/groups/local_config/10gen-mms-agent
