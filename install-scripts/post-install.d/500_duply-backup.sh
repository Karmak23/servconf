#!/bin/bash -e

#source ${SERVCONF_COMMON}

# be sure the copied data has restricted
# permissions, else duply will refuse to run.
chown -R root: /etc/duply
chmod -R g-rwx,o-rwx /etc/duply
