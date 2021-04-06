#!/usr/bin/env python3

import tkinter as tk
from ctypes import OleDLL, windll
from tkinter import font, ttk
from typing import Set

INTEGERS: Set[str] = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}


class KeepAwake:
    ES_CONTINUOUS = 0x80000000
    ES_SYSTEM_REQUIRED = 0x00000001

    def __init__(self):
        self.kept_awake: bool = False

    def prevent_sleep(self):
        self.kept_awake = True
        windll.kernel32.SetThreadExecutionState(
            self.ES_CONTINUOUS | self.ES_SYSTEM_REQUIRED
        )

    def allow_sleep(self):
        self.kept_awake = False
        windll.kernel32.SetThreadExecutionState(self.ES_CONTINUOUS)


keep_awake = KeepAwake()


class Gui(tk.Tk):
    def __init__(self):
        super().__init__()

        OleDLL("shcore").SetProcessDpiAwareness(1)  # Make the text crisp

        # Theming
        ttk.Style().theme_use("vista")
        default_font = font.nametofont("TkDefaultFont")
        default_font.configure(family="Segoe UI", size=12)

        super().wm_title("Keep Awake")

        label = tk.Label(text="Time (Minutes)")
        label.grid(column=1, row=1, padx=5, pady=5)

        time = tk.StringVar()
        time_entry = ttk.Entry(
            self,
            textvariable=time,
            validate="key",
            validatecommand=(self.register(self.validate_integer), "%P"),
        )
        time_entry.grid(column=2, row=1, padx=5, pady=5)
        self.time_entry = time_entry

        submit_button = ttk.Button(
            self,
            text="Keep Awake",
            command=self.start_timer,
        )
        submit_button.grid(column=3, row=1, padx=5, pady=5)

        asleep = tk.Label(text="Sleep Permitted")
        asleep.grid(column=2, row=2, padx=5, pady=5)
        self.asleep = asleep

    def validate_integer(self, potential_integer: str) -> bool:
        for char in potential_integer:
            if char not in INTEGERS:
                return False
        return True

    def start_timer(self):
        self.asleep["text"] = "Sleep Blocked"
        keep_awake.prevent_sleep()
        self.after(int(self.time_entry.get()) * 60000, self.end_timer)

    def end_timer(self):
        self.asleep["text"] = "Sleep Permitted"
        keep_awake.allow_sleep()


if __name__ == "__main__":
    Gui().mainloop()
