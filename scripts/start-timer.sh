#!/bin/sh

pwd=/home/taham/.config/sway/scripts

echo $(cd $pwd/timer-input/ && godot ./main.tscn)

mv $pwd/timer-input/time.txt $pwd/../data/time_of_timer.txt

$pwd/put_timer_in_epoch.sh

rm -rf $pwd/../data/time_of_timer.txt
