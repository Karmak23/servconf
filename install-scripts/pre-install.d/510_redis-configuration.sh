#!/bin/bash -e

if [[ -d /usr/bin/redis-cli ]]; then
    cp ${SERVCONF_PATH}/etc/redis/redis.conf /etc/redis
fi
