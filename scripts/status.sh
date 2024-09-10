#!/usr/bin/env sh

isReconnecting() {
    indicator=""
    if [[ -e /tmp/rc-service-network-restarting ]]; then
        indicator=" 󱛄 "
    else
        indicator=""
    fi
    echo "    {                                 "
    echo "       \"full_text\": \"$indicator\", "
    echo "       \"color\": \"#00ff75\"         "
    echo "    }                                 "
}

isRecording() {
    indicator=""
    if [[ -e /tmp/wf-recording-rn ]]; then
        indicator="   "
    else
        indicator=""
    fi
    echo "    {                                 "
    echo "       \"full_text\": \"$indicator\", "
    echo "       \"color\": \"#ff0000\"         "
    echo "    }                                 "
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
    isReconnecting
    echo -n ","
    isRecording
    echo -n ","
    formatDate
    echo "],"
    sleep 1
done


