#!/usr/bin/env bash
# Exit 0 if this machine has a battery, non-zero otherwise.
# Used by tmux.conf to decide whether to show the battery status module.
if [[ "$(uname)" == "Darwin" ]]; then
    pmset -g batt 2>/dev/null | grep -q "InternalBattery"
else
    ls /sys/class/power_supply 2>/dev/null | grep -q "^BAT"
fi
