#!/bin/bash

source "$DOTFILES/lib/task.sh"

step "Installing pipx..."
brew install pipx

# Install mpm.
step "Installing mpm..."
pipx install meta-package-manager

# Refresh all package managers.
step "Refreshing package managers..."
mpm --verbosity INFO sync
