#!/bin/bash -e



if ! has_line '^MAILTO' /etc/crontab; then
    echo -n "Installing crontab MAILTO…"

    sed -ie "s#^\(PATH.*\)\$#MAILTO=olive@licorn.org\n\1#" /etc/crontab

    echo " done."


fi
