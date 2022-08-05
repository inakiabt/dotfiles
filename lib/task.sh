#!/bin/bash
set -Eeuo pipefail

[ ! "$IS_DOTFILES_RUN" == "true" ] && echo "Please run this script from the dotfiles repo root." && exit 1

source "$DOTFILES/lib/utils.sh"

sudo -v

# Keep-alive: update existing sudo time stamp if set, otherwise do nothing.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

if [ "$DEBUG_ENABLED" -eq "1" ]; then
  echo "Debug mode enabled."
  set -x
fi

if [ "$ARGS_PARSED" -eq "0" ]; then
  echo "You can't run this task directly. Please use: run.sh {task} "
  exit 1
fi
