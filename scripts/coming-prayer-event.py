#!/usr/bin/env python

with open("/tmp/python_result", "w") as file:
    file.write(__name__)

from datetime import datetime, timedelta
from typing import List

current_time = datetime.strptime(datetime.now().strftime("%H:%M"), "%H:%M")
prayers = ("Fajr", "Sunrise", "Dhuhr", "Asr", "Asr_end", "Maghrib", "Isha", "Midnight")


def to_datetime(string: str) -> datetime:
    fixed_12 = string.replace("00:", "12:")
    return datetime.strptime(fixed_12, "%I:%M %p")


def get_time_left(upcoming_timing: datetime):
    time = upcoming_timing - current_time
    return datetime.strftime(datetime.strptime("00", "%M") + time, "%H:%M")


def check_prayer_timings(timings: List[str]):
    for index, timing in enumerate(timings):
        prayer_time = to_datetime(timing)
        if prayer_time > current_time:
            return prayers[index], timing, get_time_left(prayer_time)
    return None


def check_early_midnight(timings: List[str]):
    # If midnight is AM it will get ignored, cause it comes at last
    midnight_time = to_datetime(timings[-1])
    if "AM" in timings[-1] and midnight_time > current_time:
        return prayers[-1], timings[-1], get_time_left(midnight_time)
    else:
        return None


def check_tommorow_prayers(timings: List[str]):
    # Perhaps prayer timings for tommorow are upcoming
    # Midnight can be tommorow or today
    if "AM" in timings[-1]:
        midnight_time = to_datetime(timings[-1]) + timedelta(days=1)
        return prayers[-1], timings[-1], get_time_left(midnight_time)
    else:
        fajr_time = to_datetime(timings[0]) + timedelta(days=1)
        return prayers[0], timings[0], get_time_left(fajr_time)


def get_prayer():
    with open("/home/taham/.config/sway/data/prayer.csv", "r") as file:
        timings = file.read().splitlines()

        result = check_early_midnight(timings)
        if result is not None:
            return result

        result = check_prayer_timings(timings)
        if result is not None:
            return result

        return check_tommorow_prayers(timings)


if __name__ == "__main__":
    import sys
    import time

    if sys.argv.__len__() == 2:
        custom_time: str = sys.argv[1]
        current_time = datetime.strptime(custom_time, "%H:%M")

    while True:
        current_time = datetime.strptime(datetime.now().strftime("%H:%M"), "%H:%M")
        prayer, timing, time_left = get_prayer()
        with open("/home/taham/.config/sway/data/coming_prayer.txt", "w") as file:
            file.write(f"{prayer}\n{timing}\n{time_left}\n{time_left}")

        time.sleep(15)
