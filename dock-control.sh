#!/bin/bash
if [ "$1" == "add" ]; then
        /home/patrick/.screenlayout/uni-triple.sh
        setxkbmap -layout eu -option caps:escape
        sudo systemctl stop netctl-auto@wlp2s0.service
        sudo netctl start dock-dhcp-noclientid
elif [ "$1" == "remove" ]; then
        /home/patrick/.screenlayout/single.sh
        sudo netctl stop dock-dhcp-noclientid
        sudo systemctl start netctl-auto@wlp2s0.service
fi
