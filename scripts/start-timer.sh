#!/bin/sh

pwd=/home/taham/.config/sway/scripts

echo "5m 10m 15m 20m 30m" | awk 'BEGIN {RS=" "; ORS="\n"} { print $0 }' | dmenu > $pwd/timer-input/time.txt
#echo $(cd $pwd/timer-input/ && godot ./main.tscn)

mv $pwd/timer-input/time.txt $pwd/../data/time_of_timer.txt

$pwd/put_timer_in_epoch.sh

rm -rf $pwd/../data/time_of_timer.txt
