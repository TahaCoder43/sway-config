#!/usr/bin/env sh

source /home/taham/.coords

touch /tmp/please-worky

while true; do
    curl_result=$(curl --get \
        -d longitude=$longitude \
        -d latitude=$latitude \
        -d school=1 \
        -d method=1 \
        https://api.aladhan.com/v1/timings/$(date +%d-%m-%Y)\
    )

    echo $curl_result | /home/taham/.config/sway/scripts/extract-timings.py > /home/taham/.config/sway/data/prayer.csv

    sleep $((3600*4))
done 
