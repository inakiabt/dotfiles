#!/usr/bin/env bash
set -Eeuo pipefail

source "$HOME/.dotfiles/lib/exports.sh"
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
