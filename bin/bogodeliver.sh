#!/bin/bash
# Deliver mails using Dovecot LDA
# by first passing it through Bogofilter

/usr/bin/bogofilter -u -e -p | /usr/lib/dovecot/deliver "$@"
