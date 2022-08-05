#!/usr/bin/env bash
set -Eeuo pipefail

CURRENT_DOTFILES=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$CURRENT_DOTFILES/config.sh"
if [ "$CURRENT_DOTFILES" != "$DOTFILES" ]; then
  echo "Error: The current dotfiles directory is not the same as the one in the config file."
  echo "Current: $CURRENT_DOTFILES"
  echo "Config: $DOTFILES"
  exit 1
fi

source "$DOTFILES/lib/exports.sh"
source "$DOTFILES/lib/utils.sh"
source "$DOTFILES/lib/args.sh"

TASKS=$*
echo "You are about to run the following tasks: $TASKS"

# Iterate over all tasks and run them.
for TASK in $TASKS; do
  [ "$ACCEPT_ENABLED" -eq "0" ] && read -rp "Run task \"$TASK\". Are you sure? (y/n) " -n 1 || REPLY="y";
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🔥 Running \"$TASK\"..."
    echo "###############################################"
    (bash "$DOTFILES/tasks/$TASK.sh" 2>&1) || (echo "Failed. Aborting..." && exit 1)
    echo "###############################################"
    echo "✅  Done"
  else
    echo "Skipping..."
  fi
  echo ""
done
