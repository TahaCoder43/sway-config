#!/usr/bin/env sh

screenrecord_indicator="   "
reconnect_indicator=" 󱛄 "
stopwatch_indicator="󱎫"
stopwatch_paused_indicator="󱫪"
start_seconds=0
saved_seconds=0

stopwatch() {
    if [[ -e /tmp/stopwatch-ticking ]]; then 
        if [[ $start_seconds -eq 0 ]]; then
            start_seconds=$(date +%s)
        fi
        now_seconds=$(date +%s)
        time_in_seconds=$(($now_seconds - $start_seconds + $saved_seconds))

        seconds=$(($time_in_seconds % 60))
        minutes=$(($time_in_seconds / 60 % 60))
        hours=$(($time_in_seconds / 3600))

        time="$hours:$minutes:$seconds"
        text=" $stopwatch_indicator $time "

        echo "    {                                 "
        echo "       \"full_text\": \"$text\", "
        echo "       \"color\": \"#ff0000\"         "
        echo "    },                                "
    fi

    if [[ -e /tmp/stopwatch-paused ]]; then
        saved_seconds=$time_in_seconds
        start_seconds=0
        text=" $stopwatch_paused_indicator $time "
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

formatDate() {
    date=$(date +'%b %d %Y | %X')
    echo "    {                            "
    echo "       \"full_text\": \" $date \", "
    echo "       \"align\": \"center\"     "
    echo "    }                            "
}

echo '{"version": 1}\n'
echo '['
while : 
do
    echo "["
    stopwatch
    isReconnecting
    isRecording
    formatDate
    echo "],"
    sleep 0.5
done


