#!/usr/bin/env python3

# awake.pyw
# https://github.com/gucci-on-fleek/scripts/
# SPDX-License-Identifier: MPL-2.0+
# SPDX-FileCopyrightText: 2021 gucci-on-fleek
# Requires: python3, Windows

# This script allows you to prevent your computer from sleeping. It opens
# up a dialog box that allows for you to enter the number of minutes that
# you want to keep your computer awake. This script only uses modules from
# the Python Standard Library, so it will work on any Windows computer
# with a Python installation.

import tkinter as tk
from ctypes import OleDLL, windll
from tkinter import font, ttk
from typing import Set

INTEGERS: Set[str] = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}


class SleepAvailability:
    """Helper class to set the asleep/wake state of a Windows computer"""

    ES_CONTINUOUS = 0x80000000  # Set sleep state until otherwise modified
    ES_SYSTEM_REQUIRED = 0x00000001  # Prevent sleep, but allow the monitor to turn off

    def __init__(self):
        self.kept_awake: bool = False

    def prevent_sleep(self) -> None:
        self.kept_awake = True
        windll.kernel32.SetThreadExecutionState(
            self.ES_CONTINUOUS | self.ES_SYSTEM_REQUIRED
        )

    def allow_sleep(self) -> None:
        self.kept_awake = False
        windll.kernel32.SetThreadExecutionState(self.ES_CONTINUOUS)


class SleepDialog(tk.Tk, SleepAvailability):
    """Show a dialog to allow the user to set the sleep availability state"""

    def __init__(self):
        # Initialize all of the base classes
        for base in self.__class__.__bases__:
            base.__init__(self)

        # Enable UI scaling to make the text crisp on high DPI displays
        OleDLL("shcore").SetProcessDpiAwareness(1)

        # Match the theme as close as possible to the standard Windows style
        ttk.Style().theme_use("vista")
        default_font = font.nametofont("TkDefaultFont")
        default_font.configure(family="Segoe UI", size=12)
        self.resizable(False, False)

        # Widgets
        super().wm_title("Keep Awake")

        label = ttk.Label(text="Time (Minutes)")
        label.grid(column=1, row=1, padx=5, pady=5)

        time = tk.StringVar()
        time_entry = ttk.Entry(
            self,
            textvariable=time,
            validate="key",
            validatecommand=(self.register(self.validate_integer), "%P"),
            font=("Segoe UI", 12),  # ttk.Entry does not inherit default font
        )
        time_entry.grid(column=2, row=1, padx=5, pady=5)
        time_entry.focus()
        self.time_entry = time_entry

        submit_button = ttk.Button(
            self,
            text="Keep Awake",
            command=self.start_sleep_prevention,
        )
        submit_button.grid(column=3, row=1, padx=5, pady=5)

        # Let pressing "Enter" be equivalent to clicking the button
        self.bind("<Return>", self.start_sleep_prevention)

        sleep_state = ttk.Label(text="Sleep Permitted")
        sleep_state.grid(column=2, row=2, padx=5, pady=5)
        self.sleep_state = sleep_state

    @staticmethod
    def validate_integer(potential_integer: str) -> bool:
        """Ensure that a string only consists of digits"""
        for char in potential_integer:
            if char not in INTEGERS:
                return False
        return True

    def start_sleep_prevention(self, *args, **kwargs) -> None:
        """Prevent sleep, and set a timer to reallow sleep again"""
        try:
            minutes_to_wait = int(self.time_entry.get())
        except ValueError:
            self.sleep_state["text"] = "Invalid Input"
            return

        self.prevent_sleep()
        self.sleep_state["text"] = "Sleep Blocked"

        self.after(
            minutes_to_wait * 60_000,  # Tk.after takes input in milliseconds
            self.end_sleep_prevention,
        )

    def end_sleep_prevention(self) -> None:
        self.allow_sleep()
        self.sleep_state["text"] = "Sleep Permitted"


if __name__ == "__main__":
    SleepDialog().mainloop()
