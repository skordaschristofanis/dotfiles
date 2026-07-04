#!/usr/bin/env bash
set -euo pipefail

ULTRAWIDE="DP-1"
PORTRAIT="DP-2"

# Turn off unused outputs (ignore errors if already off)
for output in DP-3 HDMI-1 HDMI-1-2 DP-1-4 DP-1-5; do
  xrandr --output "$output" --off 2>/dev/null || true
done

# Layout:
#   DP-1 — 3840x1600 ultrawide (left, primary) @ 144 Hz
#   DP-2 — 2560x1440 rotated right (1440x2560), right of ultrawide @ ~144 Hz
#
# Vertical alignment: portrait nearly centered on ultrawide, slightly more
# extending below than above (420 px above / 540 px below at 1600 px ultrawide height).
xrandr \
  --output "$ULTRAWIDE" --primary --mode 3840x1600 --rate 144 --pos 0x0 \
  --output "$PORTRAIT" --mode 2560x1440 --rate 144 --rotate right --pos 3840x-420
