#!/usr/bin/env bash

screenrecord_indicator="   "
reconnect_indicator=" 󱛄 "
stopwatch_indicator="󱎫"
stopwatch_paused_indicator="󱫪"
start_seconds=0
saved_seconds=0

seconds_to_iso_time() {
    if [[ -z $1 ]]; then
        return 1
    fi
    total_seconds=$1

    seconds=$(($total_seconds % 60))
    minutes=$(($total_seconds / 60 % 60))
    hours=$(($total_seconds / 3600))

    { read hours; read minutes; read seconds; } < <(
        echo $hours,$minutes,$seconds | awk '
            BEGIN { RS=","; } $0 < 10 { print "0"$0 }
            $0 > 9 { print $0 }
        '
    )

    echo "$hours:$minutes:$seconds"
}

timer_done() {
    if [[ ! -e  /tmp/timer-done ]]; then
        return 0
    fi
    text=" 󱫐 TIMER DONE "

    echo "    {                                 "
    echo "       \"full_text\": \"$text\",      "
    echo "       \"color\": \"#222222\",        "
    echo "       \"background\": \"#00ff00\"    "
    echo "    },                                "
}

timer() {
    if [[ ! -e  /tmp/epoch_of_timer.txt ]]; then
        return 0
    fi
    if [[ -e /tmp/timer-done ]]; then
        return 0
    fi

    read epoch_time < /tmp/epoch_of_timer.txt
    current_time=$(date +%s)
    seconds_left=$(($epoch_time - $current_time))

    if [[ $seconds_left -le 0 ]]; then
        rm -rf /tmp/epoch_of_timer.txt
        echo $epoch_time > /tmp/timer-done
        return 0
    fi

    timer_time=$(seconds_to_iso_time $seconds_left)
    text=$timer_time

    echo "    {                                 "
    echo "       \"full_text\": \" $text \",      "
    echo "       \"color\": \"#ffcc88\"         "
    echo "    },                                "


}

prayer() {
    { read prayer; read timing; read time_left; } < /home/taham/.config/sway/data/coming_prayer.txt
    text="$prayer $timing: $time_left"

    echo "    {                                 "
    echo "       \"full_text\": \" $text \",      "
    echo "       \"color\": \"#cc00ff\"         "
    echo "    },                                "

}

stopwatch() {
    if [[ -e /tmp/stopwatch-ticking ]]; then 
        if [[ $start_seconds -eq 0 ]]; then
            start_seconds=$(date +%s)
        fi
        now_seconds=$(date +%s)
        time_in_seconds=$(($now_seconds - $start_seconds + $saved_seconds))

        stopwatch_time=$(seconds_to_iso_time $time_in_seconds)
        text=" $stopwatch_indicator $stopwatch_time "

        echo "    {                                 "
        echo "       \"full_text\": \"$text\", "
        echo "       \"color\": \"#ff0000\"         "
        echo "    },                                "
    fi

    if [[ -e /tmp/stopwatch-paused ]]; then
        saved_seconds=$time_in_seconds
        start_seconds=0
        text=" $stopwatch_paused_indicator $stopwatch_time "
        echo "    {                                 "
        echo "       \"full_text\": \"$text\", "
        echo "       \"color\": \"#66aaff\"         "
        echo "    },                                "
    fi

    if [[ -e /tmp/stopwatch-reset ]]; then
        saved_seconds=0
    fi
}

isReconnecting() {
    if [[ -e /tmp/rc-service-network-restarting ]]; then
        echo "    {                                 "
        echo "       \"full_text\": \"$reconnect_indicator\", "
        echo "       \"color\": \"#00ff75\"         "
        echo "    },                                "
    fi
}

isRecording() {
    if [[ -e /tmp/wf-recording-rn ]]; then
        echo "    {                                              "
        echo "       \"full_text\": \"$screenrecord_indicator\", "
        echo "       \"color\": \"#ff0000\"                      "
        echo "    },                                             "
    fi
}

fastingStatus() {
    text=""
    if [[ -e /tmp/fast-tommorow ]]; then
        text="The Fast is tommorow"
        color="#ffaa00"
    elif [[ -e /tmp/fast-today ]]; then
        text="The Fast is today"
        color="#ff2222"
    elif [[ -e /tmp/fasting ]]; then
        text="Fasting right now"
        color="#00ff75"
    else
        text="No fast"
        color="#4422ff"
    fi
        
    echo "    {                                              "
    echo "       \"full_text\": \" $text \",                 "
    echo "       \"color\": \"$color\"                      "
    echo "    },                                             "
}

formatDate() {
    date=$(date +'%a %d %b %Y | %I:%M:%S %p')
    echo "    {                            "
    echo "       \"full_text\": \" $date \" "
    echo "    }                            "
}

space() {
    echo "    {                                 "
    echo "       \"full_text\": \" \",          "
    echo "       \"min_width\": $1              "
    echo "    },                                "
}

echo '{"version": 1}\n'
echo '['
while true; do
    echo "["
    stopwatch
    timer_done
    timer
    isReconnecting
    isRecording
    fastingStatus
    prayer
    formatDate
    echo "],"
    sleep 1

done

