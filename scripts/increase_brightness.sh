#!/usr/bin/env sh

current=$(/usr/bin/brightnessctl get)

/usr/bin/brightnessctl set $(($current+1))
