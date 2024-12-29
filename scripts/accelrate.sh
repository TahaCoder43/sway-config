#!/bin/sh

if [[ -z $1 ]]; then
    echo No max_speed argument provided > /tmp/sway-log/accelrate.log
    exit 1
fi

if [[ -z $2 ]]; then
    echo No accelration argument provided >> /tmp/sway-log/accelrate.log
    exit 1
fi

speed_path=/home/taham/.config/sway/data/speed
max_speed=$1
accelration=$2
read current_speed < $speed_path

if [[ $current_speed -ge $max_speed ]]; then
    echo $max_speed > $speed_path # current speed can grow greater than max speed
    exit 0
fi

new_speed=$(( $current_speed + $accelration))
echo $new_speed > /home/taham/.config/sway/data/speed


