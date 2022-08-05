#!/bin/bash

source "$DOTFILES/lib/task.sh"

NPM_DEFAULT_VERSION="16.13.1"

step "Installing nvm..."
brew install nvm

source "$DOTFILES/lib/nvm.sh"

step "Installing npm..."
nvm install "$NPM_DEFAULT_VERSION"
