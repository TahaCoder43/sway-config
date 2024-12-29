#!/usr/bin/env sh

nmcli connection show |
    awk 'NR!=1 { print $0 }' |
    dmenu -l 5 |
    awk '{ print $(NF-2) }' |
    {
        read uuid;
        nmcli connection down $uuid 2>&1; 
    } | 
    dmenu -l 1 -p "result"
