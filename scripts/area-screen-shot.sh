#!/usr/bin/env sh

dir_path=/home/taham/Pictures/Screenshots/$(date +%b-%g)
screenshot_path=$dir_path/$(date +%d_%a_%H:%M:%S).png

mkdir $dir_path 2> /dev/null; \

flameshot gui --clipboard --path $screenshot_path | {
    read output;

    if echo $output | awk '/flameshot: info: Screenshot aborted/ { print $0 }' ; then 
        notify-send -t 3000 --icon=$XDG_CONFIG_HOME/sway/icons/Camera.jpg "Screenshot taken."
    else 
        notify-send -t 3000 --icon=$XDG_CONFIG_HOME/sway/icons/Camera.jpg "Screenshot failed."
    fi
}


