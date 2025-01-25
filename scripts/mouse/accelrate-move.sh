#!/usr/bin/env sh

### Does not work :(

speed=$1
accelration=$2
max_speed=$3
direction=$4

echo true > /home/taham/.config/sway/data/moving

# try pkill instead of all this reading stuff
moving() {
    read moving < /home/taham/.config/sway/data/moving
    if [[ $moving == "false" ]]; then
        return 1
    fi
}

while moving; do 
    echo $speed > /home/taham/.config/sway/data/value
    if [[ $direction == "right" ]]; then
        ydotool mousemove -x $speed -y 0
    elif [[ $direction == "left" ]]; then
        ydotool mousemove -x -$speed -y 0
    elif [[ $direction == "up" ]]; then
        ydotool mousemove -x 0 -y -$speed
    elif [[ $direction == "down" ]]; then
        ydotool mousemove -x 0 -y $speed
    fi

    if [[ $speed -lt $max_speed ]]; then
        speed=$(($speed+$accelration))
    fi
    sleep 0.03
done

