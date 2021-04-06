#!/usr/bin/env python3

import ctypes
from appJar import gui

ctypes.OleDLL("shcore").SetProcessDpiAwareness(1)


class SleepStatus:
    ES_CONTINUOUS = 0x80000000
    ES_SYSTEM_REQUIRED = 0x00000001

    def __init__(self):
        self.can_sleep = True

    @property
    def can_sleep(self):
        return self.can_sleep

    @can_sleep.setter
    def can_sleep(self, val):
        if val:
            self._allow_sleep()
        if not val:
            self._prevent_sleep()

    def _prevent_sleep(self):
        ctypes.windll.kernel32.SetThreadExecutionState(
            SleepStatus.ES_CONTINUOUS | SleepStatus.ES_SYSTEM_REQUIRED
        )

    def _allow_sleep(self):
        ctypes.windll.kernel32.SetThreadExecutionState(SleepStatus.ES_CONTINUOUS)


sleep_status = SleepStatus()


def click(button):
    if button == "Sleep":
        time_to_wait = app.getEntry("Time")
        sleep_status.can_sleep = False
        if time_to_wait:
            time_to_wait *= 60000
            time_to_wait = int(time_to_wait)
            id = app.after(time_to_wait, sleep_status._allow_sleep)


with gui("Awake", useTtk=True) as app:
    app.setTtkTheme("vista")
    app.setPadding(10, 10)
    app.addNumericEntry("Time", 0, 0)
    app.setEntryDefault("Time", "Minutes")
    # app.setFocus("Time")
    app.addButton("Awake", click, 0, 1)
    app.setEntryTooltip("Time", "Leave blank to wait indefinitely")
