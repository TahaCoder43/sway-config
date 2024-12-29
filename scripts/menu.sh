#!/usr/bin/env sh

if ! ps -A | grep dmenu; then
    bash -c "compgen -c" | dmenu -nb "#110022" -l 10 | bash
else 
    pkill dmenu
fi
