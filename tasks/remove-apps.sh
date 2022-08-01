#!/bin/bash

source "$DOTFILES/lib/task.sh"

# Remove unused apps.
step "Removing unused apps..."
mas uninstall 682658836 || true  # GarageBand
mas uninstall 409201541 || true  # Pages
