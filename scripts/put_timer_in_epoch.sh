#!/bin/sh

read time < /home/taham/.config/sway/data/time_of_timer.txt
time_in_seconds=0

if echo $time | grep -o "[mhs]$"; then
    unit_match=$(echo $time | grep -o "[mhs]$")
    multiplier=1
    if [[ $unit_match == "h" ]]; then
        multiplier=3600
    elif [[ $unit_match == "m" ]]; then
        multiplier=60
    elif [[ $unit_match == "s" ]]; then
        multiplier=1
    else
        echo Error unit should only be h, m or s
        exit 1
    fi

    value=$(echo $time | grep -o [0-9]*)
    echo $value $multiplier
    time_in_seconds=$(($value * $multiplier))
else
    values=$(echo $time | awk -F: '{ print NF }')
    if [[ $values -eq 2 ]]; then
        { read minutes; read seconds; } < <(echo $time | awk 'BEGIN {RS=":"} { print $0 }')
        time_in_seconds=$(($minutes*60 + $seconds))
    elif [[ $values -eq 3 ]]; then
        { read hours; read minutes; read seconds; } < <(echo $time | awk 'BEGIN {RS=":"} { print $0 }')
        time_in_seconds=$(($hours*3600 + $minutes*60 + $seconds))
    else
        echo Error values should be 1 or 2
        exit 1
    fi
fi

epoch_time=$(($(date +%s) + $time_in_seconds))
echo $epoch_time > /tmp/epoch_of_timer.txt
