#!/bin/bash

source "$DOTFILES/lib/task.sh"

# Update all macOS packages.
echo "Updating macOS packages"
sudo softwareupdate --install --all
