#!/usr/bin/env bash

# Variables
BAR=bottom
CFG="$HOME/.config/polybar/config.ini"
LOG="/tmp/$USER-polybar-$BAR.log"

# Platform Detection
export BACKLIGHT="$(ls -1 /sys/class/backlight)"

# Terminate running bars; ensure ipc is enabled for each bar (killall -q polybar)
polybar-msg cmd quit

# Split log
echo "---" | tee -a "$LOG"

# Launch bar
polybar --config="$CFG" "$BAR" 2>&1 | tee -a "$LOG" & disown
