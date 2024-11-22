#!/usr/bin/env sh

if [[ -e /tmp/wf-recording-rn ]]; then
    rm -rf /tmp/wf-recording-rn
    kill -s INT $(ps | awk '{print $4" "$1}' | sed '/^wf-recorder/!d' | awk '{print $2}')
else
    folderpath=/home/taham/Videos/ScreenRecordings/$(date +%b-%g)/
    filepath=$folderpath/$(date +%d_%a_%H:%M:%S).mp4
    touch /tmp/wf-recording-rn
    mkdir $folderpath
    wf-recorder --output LVDS-1 --file $filepath --geometry "$(slurp)"
    wl-copy < $filepath # This works, but for some reason discord can't paste in video files (it's a electron glitch on XWayland ig)
fi
