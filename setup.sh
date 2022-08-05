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
source "$DOTFILES/lib/args.sh"

# Run tasks
TASKS="
checks
folders
setup-brew
initial
remove-apps
setup-shell
meta-package-manager
setup-1password
keys
private-files-restore
macos
xbar
mackup
brew
update-macos
cleanup
post-checks
dock
open-apps
"

# show the list of task to run and ask for confirmation
echo "You are about to run the following tasks:"
echo "$TASKS"
echo ""
read -rp "Are you ready? (y/n) " -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
  for task in $TASKS; do
    (bash "$DOTFILES/run.sh" "$task" "$*" && echo "Done") || (echo "Failed. Aborting..." && exit 1)
    echo ""
  done
else
  echo "Aborting..."
  exit 1
fi
