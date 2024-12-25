#!/bin/sh

# Cleaning up previous files
rm -rf /tmp/fast-tommorow /tmp/fast-today /tmp/fasting

weekday=$(date +%w)
monday=1
thursday=4

is_fajr_coming() {
    fajr_prayer_timing=$(awk 'NR==1' /home/taham/.config/sway/data/prayer.csv | while read time; do date -d "$time" +"%s"; done )
    current_time=$(date +%s)

    echo $(($fajr_prayer_timing > $current_time)) 
}

has_maghrib_passed() {
    maghrib_prayer_timing=$(awk 'NR==6' /home/taham/.config/sway/data/prayer.csv | while read time; do date -d "$time" +"%s"; done )
    current_time=$(date +%s)

    echo "timings are $(($maghrib_prayer_timing <= $current_time))" > /tmp/some-log
    echo $(($maghrib_prayer_timing <= $current_time)) 
}

if [[ $weekday -eq $monday || $weekday -eq $thursday ]]; then
    echo today is fasting day

    if [[ $(is_fajr_coming) -eq 1 ]]; then
        touch /tmp/fast-today
    elif [[ $(has_maghrib_passed) -eq 0 ]]; then
        touch /tmp/fasting
    fi
elif [[ $weekday -eq $(($monday - 1)) || $weekday -eq $(($thursday - 1)) ]]; then
    echo tommorow you have to fast
    touch /tmp/fast-tommorow
else
    echo do other acts of worship
fi

