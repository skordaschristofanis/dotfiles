#!/usr/bin/env bash
set -euo pipefail

DIR="${XDG_CONFIG_HOME:-$HOME/.config}/display"

case "${XDG_SESSION_TYPE:-x11}" in
  wayland)
    # Hyprland/Sway load monitor config themselves
    ;;
  *)
    # x11, xorg, tty (startx), or unset — all use xrandr
    if command -v autorandr >/dev/null 2>&1 && autorandr --change 2>/dev/null; then
      :
    elif [[ -x "$DIR/x11/set-monitors.sh" ]]; then
      "$DIR/x11/set-monitors.sh"
    fi
    ;;
esac