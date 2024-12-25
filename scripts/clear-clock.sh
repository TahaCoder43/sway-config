#!/usr/bin/env sh

if [[ -e /tmp/stopwatch-paused ]]; then
    rm -rf /tmp/stopwatch-paused
    touch /tmp/stopwatch-reset
    sleep 1
    rm -rf /tmp/stopwatch-reset
fi 

if [[ -e /tmp/timer-done ]]; then
    rm -rf /tmp/timer-done
fi
