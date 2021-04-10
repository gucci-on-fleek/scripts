#!/usr/bin/env python3

# enbox.py
# https://github.com/gucci-on-fleek/scripts/
# SPDX-License-Identifier: MPL-2.0+
# SPDX-FileCopyrightText: 2021 gucci-on-fleek
# Requires: python3.6+

# This script will enclose any text in boxes like these:
#  regular   double     thick     curved
# ┌───────┐ ╔═══════╗ ┏━━━━━━━┓ ╭───────╮
# │  One  │ ║  One  ║ ┃  One  ┃ │  One  │
# │  Two  │ ║  Two  ║ ┃  Two  ┃ │  Two  │
# │ Three │ ║ Three ║ ┃ Three ┃ │ Three │
# └───────┘ ╚═══════╝ ┗━━━━━━━┛ ╰───────╯

from sys import argv, stdin
from typing import Dict, List, Literal, cast

BoxTypes = Literal["double", "thick", "regular", "curved"]
Positions = Literal[
    "top_left", "top_right", "bottom_left", "bottom_right", "horizontal", "vertical"
]


def enbox(string: str, box_type: BoxTypes) -> str:
    """Encloses a (multiline) string in a user-selected box.

    Args:
        string (str): The string to enclose in a box
        BOX_TYPE ("double" | "thick" | "regular" | "curved"): The type of box

    Returns:
        str: The string enclosed in the box.
    """

    box_parts: Dict[BoxTypes, Dict[Positions, str]] = {
        "double": {
            "top_left": "╔",
            "top_right": "╗",
            "bottom_left": "╚",
            "bottom_right": "╝",
            "horizontal": "═",
            "vertical": "║",
        },
        "thick": {
            "top_left": "┏",
            "top_right": "┓",
            "bottom_left": "┗",
            "bottom_right": "┛",
            "horizontal": "━",
            "vertical": "┃",
        },
        "regular": {
            "top_left": "┌",
            "top_right": "┐",
            "bottom_left": "└",
            "bottom_right": "┘",
            "horizontal": "─",
            "vertical": "│",
        },
        "curved": {
            "top_left": "╭",
            "top_right": "╮",
            "bottom_left": "╰",
            "bottom_right": "╯",
            "horizontal": "─",
            "vertical": "│",
        },
    }
    part = box_parts[box_type]
    lines: List[str] = []

    # Tabs interfere with the length calculations and must be removed
    string = string.replace("\t", " " * 8)

    for line in string.split("\n"):
        lines.append(line)

    max_len = max(len(line) for line in lines)

    output = (  # First line
        part["top_left"] + part["horizontal"] * (max_len + 2) + part["top_right"] + "\n"
    )
    for line in string.split("\n"):
        output += (
            part["vertical"]
            + " "
            + line
            + " " * (max_len - len(line) + 1)
            + part["vertical"]
            + "\n"
        )
    output += (  # Last line
        part["bottom_left"] + part["horizontal"] * (max_len + 2) + part["bottom_right"]
    )
    return output


if __name__ == "__main__":
    if len(argv) != 2 or argv[1] not in {"double", "thick", "regular", "curved"}:
        print(enbox("enbox.py — Enclose Text in a Box", "thick"))
        print(
            enbox(f"Usage: {argv[0]} {{ regular | thick | double | curved }}", "curved")
        )
        print(enbox("Takes text input from stdin.", "double"))
        print(
            enbox(
                """Note: This may not look quite right if your font or terminal doesn’t
      support the required Unicode box drawing characters.""",
                "regular",
            )
        )
        exit(1)

    print(enbox(stdin.read().strip(), cast(BoxTypes, argv[1])))
