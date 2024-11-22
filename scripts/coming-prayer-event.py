#!/usr/bin/env python

import asyncio
import sys
import time
import subprocess
from datetime import datetime, timedelta
from typing import List

# it may be that the just 1 second before a prayer's time we sleep, so that then MAXIMUM_DISCREPENCY-1 seconds later will the clock update
MAXIMUM_DISCREPENCY = 15
PRAYERS = ("Fajr", "Sunrise", "Dhuhr", "Asr", "Asr_end", "Maghrib", "Isha", "Midnight")
EXCLUDED_PRAYERS = ("Sunrise", "Asr_end", "Midnight")


def to_datetime(string: str) -> datetime:
    fixed_12 = string.replace("00:", "12:")
    return datetime.strptime(fixed_12, "%I:%M %p")


def get_time_left(upcoming_timing: datetime, current_time: datetime):
    time = upcoming_timing - current_time
    return datetime.strftime(datetime.strptime("00", "%M") + time, "%H:%M")


def check_prayer_timings(timings: List[str], current_time: datetime):
    for index, timing in enumerate(timings):
        prayer_time = to_datetime(timing)
        if prayer_time >= current_time:
            return PRAYERS[index], timing, get_time_left(prayer_time, current_time)
    return None


def check_early_midnight(timings: List[str], current_time: datetime):
    # If midnight is AM it will get ignored, cause it comes at last
    midnight_time = to_datetime(timings[-1])
    if "AM" in timings[-1] and midnight_time > current_time:
        return PRAYERS[-1], timings[-1], get_time_left(midnight_time, current_time)
    else:
        return None


def check_tommorow_prayers(timings: List[str], current_time: datetime):
    # Perhaps prayer timings for tommorow are upcoming
    # Midnight can be tommorow or today
    if "AM" in timings[-1]:
        midnight_time = to_datetime(timings[-1]) + timedelta(days=1)
        return PRAYERS[-1], timings[-1], get_time_left(midnight_time, current_time)
    else:
        fajr_time = to_datetime(timings[0]) + timedelta(days=1)
        return PRAYERS[0], timings[0], get_time_left(fajr_time, current_time)


def get_prayer(current_time: datetime):
    with open("/home/taham/.config/sway/data/prayer.csv", "r") as file:
        timings = []
        while timings == []:
            timings = file.read().splitlines()
            time.sleep(1) 

        result = check_early_midnight(timings, current_time)
        if result is not None:
            return result

        result = check_prayer_timings(timings, current_time)
        if result is not None:
            return result

        return check_tommorow_prayers(timings, current_time)


async def main():
    current_time = datetime.strptime(datetime.now().strftime("%H:%M"), "%H:%M")
    previous_time = ""

    if sys.argv.__len__() == 2:
        custom_time: str = sys.argv[1]
        current_time = datetime.strptime(custom_time, "%H:%M")
        prayer, timing, time_left = get_prayer(current_time)
        if time_left == "00:00" and prayer not in EXCLUDED_PRAYERS:
            subprocess.call(
                ["cvlc", "--play-and-exit", "/home/taham/.config/sway/data/azan1.mp3"]
            )
            subprocess.call(
                [
                    "notify-send",
                    "-t",
                    "3000",
                    "--icon=$XDG_CONFIG_HOME/sway/icons/Camera.jpg",
                    f"Time for {prayer} prayer",
                ]
            )
        print(f"{prayer} {timing}: {time_left}")
        exit(0)

    while True:
        current_time = datetime.strptime(datetime.now().strftime("%H:%M"), "%H:%M")
        prayer, timing, time_left = get_prayer(current_time)
        if current_time != previous_time:  # Only write when one minute passes
            with open("/home/taham/.config/sway/data/coming_prayer.txt", "w") as file:
                file.write(f"{prayer}\n{timing}\n{time_left}")

            if time_left == "00:00" and prayer not in EXCLUDED_PRAYERS:
                await asyncio.create_subprocess_shell(
                    "cvlc --play-and-exit /home/taham/.config/sway/data/azan1.mp3",
                )
                await asyncio.create_subprocess_shell(
                    f"notify-send -t 3000 --icon=$XDG_CONFIG_HOME/sway/icons/Camera.jpg Time for {prayer} prayer",
                )

        previous_time = current_time

        time.sleep(MAXIMUM_DISCREPENCY)


if __name__ == "__main__":
    asyncio.run(main())
