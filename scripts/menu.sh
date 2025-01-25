#!/usr/bin/env sh

if ! ps -A | grep dmenu; then
    dmenu_run -nb "#110022" -l 10
else 
    pkill dmenu
fi
