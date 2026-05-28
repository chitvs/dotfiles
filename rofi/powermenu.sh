#!/bin/bash

chosen=$(printf "Power Off\nReboot\nSuspend\nLock\nLogout" | \
  rofi -dmenu -i -p " Power" \
       -theme /usr/share/rofi/themes/gruvbox-dark-hard.rasi)

case "$chosen" in
  "Power Off") systemctl poweroff ;;
  "Reboot")    systemctl reboot ;;
  "Suspend")   systemctl suspend ;;
  "Lock")      hyprlock ;;
  "Logout")    hyprctl dispatch exit ;;
esac

