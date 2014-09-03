#!/bin/bash -e

#source ${SERVCONF_COMMON}

# clean old configuration in case it was a symlink, we now copy the dir.
[[ -L /etc/duply ]] && rm -rf /etc/duply
