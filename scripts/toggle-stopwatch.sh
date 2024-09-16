#!/usr/bin/env sh

if [[ -e /tmp/stopwatch-reset ]]; then
    exit 0
fi

if [[ -e /tmp/stopwatch-paused ]]; then
    mv /tmp/stopwatch-paused /tmp/stopwatch-ticking
elif [[ -e /tmp/stopwatch-ticking ]]; then
    mv /tmp/stopwatch-ticking /tmp/stopwatch-paused
else
    touch /tmp/stopwatch-ticking
fi
