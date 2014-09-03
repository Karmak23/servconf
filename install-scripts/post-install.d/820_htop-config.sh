#!/bin/bash -e

if [[ ! -L ~/.config/htop/htoprc ]]; then

    #mkdir -p ~${USER}/.config/htop
    #rm -rf ~${USER}/.config/htop/htoprc
    #ln -sf /etc/htoprc ~${USER}/.config/htop/htoprc
    #chown -R ${USER} ~${USER}/.config

    mkdir -p /root/.config/htop
    rm -rf /root/.config/htop/htoprc
    cp /etc/htoprc /root/.config/htop/htoprc
fi
