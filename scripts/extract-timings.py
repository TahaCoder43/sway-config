#!/usr/bin/env python

import fileinput
import json
from datetime import datetime, timedelta

stdin = ""
for line in fileinput.input():
    stdin += line

json_stdin = json.loads(stdin)
timings = json_stdin["data"]["timings"]

format = "%I:%M %p"

for name, unformatted_timing in timings.items():
    timing = datetime.strptime(unformatted_timing, "%H:%M").strftime(format)

    timings[name] = timing

fajr_time = datetime.strptime(f"02 {timings["Fajr"]}", f"%d {format}")
maghrib_time = datetime.strptime(f"01 {timings["Maghrib"]}", f"%d {format}")
night_duration = fajr_time - maghrib_time
midnight = maghrib_time + night_duration / 2
if midnight.day == 2:
    midnight -= timedelta(days=1)
midnight_formatted = midnight.strftime(format).replace("12:", "00:")

asr_end = datetime.strptime(timings["Maghrib"], format) - timedelta(minutes=40)
asr_end_formatted = asr_end.strftime(format).replace("12:", "00:")

# Fix 00:00 Am being 12:00

for name, timing in timings.items():
    timings[name] = timing.replace("12:", "00:")


print(
    timings["Fajr"],
    timings["Sunrise"],
    timings["Dhuhr"],
    timings["Asr"],
    asr_end_formatted,
    timings["Maghrib"],
    timings["Isha"],
    midnight_formatted,
    sep="\n",
)
