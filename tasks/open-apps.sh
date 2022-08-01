#!/bin/bash

source "$DOTFILES/lib/task.sh"

echo "Opening apps"
# Open apps
APP_NAMES=("Fig" "jumpcut" "iStat Menus" "Bartender 3" "BetterTouchTool" "Caffeine" "LuLu" "Daisy Disk")
for APP_NAME in "${APP_NAMES[@]}"
do
  step "Opening $APP_NAME"
  # Do not fail on missing app
  open -a "${APP_NAME}" || true
done
