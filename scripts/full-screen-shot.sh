#!/usr/bin/env sh

mkdir /home/taham/Pictures/Screenshots/$(date +%b-%g) 2> /dev/null; \

flameshot screen --clipboard --path /home/taham/Pictures/Screenshots/$(date +%b-%g)/$(date +%d_%a_%H:%M:%S).png

notify-send -t 3000 --icon=$XDG_CONFIG_HOME/sway/icons/Camera.jpg "Full Screenshot taken"

