"""
Custom kitty tab bar.

Delegates per-tab drawing to kitty's built-in powerline renderer, then
appends a right-aligned status with battery and date/time on the last tab.

Requires: `tab_bar_style custom` in kitty.conf.
"""

from __future__ import annotations

import re
import subprocess
from datetime import datetime

from kitty.boss import get_boss
from kitty.fast_data_types import Screen, add_timer, get_options, wcswidth
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    TabBarData,
    as_rgb,
    draw_tab_with_powerline,
)

# Refresh the tab bar every 2s so the clock/battery stay current.
_timer_id: int | None = None
REFRESH_SECONDS = 2.0

# Colors (packed 0xRRGGBB). `None` in a cell means "use terminal default fg".
FG_FALLBACK = 0xD0D0D0     # used if the theme lookup fails
FG_LOW_BATTERY = 0xE06C75  # red    — low battery warning
FG_ZOOM = 0xE5C07B         # yellow — zoomed/stack indicator


def _theme_fg_rgb() -> int:
    """Return the terminal's foreground color as packed 0xRRGGBB.

    kitty's Color type exposes .red/.green/.blue; in some versions/builds
    get_options().foreground is an int instead. Handle both, and fall back
    to a known-readable light gray if anything is unexpected.
    """
    try:
        c = get_options().foreground
    except Exception:
        return FG_FALLBACK
    if isinstance(c, int):
        # raw 0xRRGGBB (≤24 bits) or kitty-encoded (low byte is type tag)
        return c if c <= 0xFFFFFF else (c >> 8) & 0xFFFFFF
    red = getattr(c, "red", None)
    if red is None:
        return FG_FALLBACK
    return (c.red << 16) | (c.green << 8) | c.blue

# Nerd Font Material Design battery glyphs (nf-md-battery_*).
# Keys are percent thresholds; value is the glyph for "<= threshold" charge.
_BATTERY_LEVELS: tuple[tuple[int, str], ...] = (
    (9,   "\U000f0083"),  # battery_alert   󰂃
    (19,  "\U000f007a"),  # battery_10      󰁺
    (29,  "\U000f007b"),  # battery_20      󰁻
    (39,  "\U000f007c"),  # battery_30      󰁼
    (49,  "\U000f007d"),  # battery_40      󰁽
    (59,  "\U000f007e"),  # battery_50      󰁾
    (69,  "\U000f007f"),  # battery_60      󰁿
    (79,  "\U000f0080"),  # battery_70      󰂀
    (89,  "\U000f0081"),  # battery_80      󰂁
    (94,  "\U000f0082"),  # battery_90      󰂂
    (100, "\U000f0079"),  # battery (full)  󰁹
)
_BATTERY_CHARGING = "\U000f0084"  # battery_charging  󰂄


def _battery_icon(pct: int, charging: bool) -> str:
    if charging:
        return _BATTERY_CHARGING
    for threshold, glyph in _BATTERY_LEVELS:
        if pct <= threshold:
            return glyph
    return _BATTERY_LEVELS[-1][1]


def _get_battery() -> tuple[int, bool] | None:
    """Return (percent, charging) or None if unavailable."""
    try:
        out = subprocess.check_output(
            ["pmset", "-g", "batt"], text=True, timeout=1
        )
    except (subprocess.SubprocessError, FileNotFoundError):
        return None

    m = re.search(r"(\d+)%", out)
    if not m:
        return None
    pct = int(m.group(1))
    charging = "charging" in out.lower() and "discharging" not in out.lower()
    return pct, charging


def _current_layout_name() -> str | None:
    try:
        tm = get_boss().active_tab_manager
        if tm is not None and tm.active_tab is not None:
            return tm.active_tab.current_layout.name
    except Exception:
        return None
    return None


def _draw_right_status(draw_data: DrawData, screen: Screen, is_last: bool) -> None:
    if not is_last:
        return

    default_fg = _theme_fg_rgb()

    cells: list[tuple[int, str]] = []

    # Layout indicator — only when in stack (i.e. "zoomed")
    if _current_layout_name() == "stack":
        # nf-md-fullscreen  󰊓
        cells.append((FG_ZOOM, "\U000f0293 ZOOM  "))

    battery = _get_battery()
    if battery is not None:
        pct, charging = battery
        low = pct < 20 and not charging
        icon = _battery_icon(pct, charging)
        cells.append((FG_LOW_BATTERY if low else default_fg, f"{icon}  "))

    cells.append((default_fg, datetime.now().strftime("%Y-%m-%d %-I:%M %p")))
    cells.append((default_fg, " "))

    right_len = sum(wcswidth(text) for _, text in cells)
    padding = screen.columns - screen.cursor.x - right_len
    if padding > 0:
        screen.draw(" " * padding)

    for color, text in cells:
        screen.cursor.fg = as_rgb(color)
        screen.draw(text)

    screen.cursor.fg = 0
    screen.cursor.bg = 0

    right_len = sum(wcswidth(text) for _, text in cells)
    padding = screen.columns - screen.cursor.x - right_len
    if padding > 0:
        screen.draw(" " * padding)

    for color, text in cells:
        screen.cursor.fg = as_rgb(color)
        screen.draw(text)

    screen.cursor.fg = 0
    screen.cursor.bg = 0


def _redraw_tab_bar(_timer_id: int) -> None:
    tm = get_boss().active_tab_manager
    if tm is not None:
        tm.mark_tab_bar_dirty()


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    global _timer_id
    if _timer_id is None:
        _timer_id = add_timer(_redraw_tab_bar, REFRESH_SECONDS, True)

    end = draw_tab_with_powerline(
        draw_data, screen, tab, before, max_title_length, index, is_last, extra_data
    )
    _draw_right_status(draw_data, screen, is_last)
    return end
