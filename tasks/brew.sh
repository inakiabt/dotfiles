#!/bin/bash

source "$DOTFILES/lib/task.sh"

step "Installing bundled apps from $MACKUP/.Brewfile..."
brew bundle --file "$MACKUP/.Brewfile"

step "Use new bash_profile"
source "$HOME/.bash_profile"
