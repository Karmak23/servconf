#!/bin/bash -e

if has_line etc/postfix ${MACHINE_INSTALL_FILE}; then

    # Be sure postfix is installed, sometimes at first install
    # nullmailer gets installed in place of postfix.

    chown -R root: /etc/postfix

    DEBIAN_PRIORITY=critical DEBIAN_FRONTEND=noninteractive \
    	apt-get -o Dpkg::Options::='--force-confold' \
    		-q install postfix --yes --force-yes

    service postfix restart || service postfix start

    mailq
    postfix flush

fi
