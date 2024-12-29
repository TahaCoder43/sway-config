#!/usr/bin/env sh

nmcli device wifi list --rescan no |
    awk 'NR!=1 {
        i=match($0, /[A-Z0-9]/)
        print substr($0, i, length($0))
    }' |
    dmenu -l 5 |
    awk '{ print $1 }' |
    { 
        read bssid;
        nmcli device wifi connect $bssid password $(echo "" | dmenu -p "password: ");
    } 2>&1 | 
    dmenu -l 1 -p "result"
