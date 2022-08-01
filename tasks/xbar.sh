#!/bin/bash

source "$DOTFILES/lib/task.sh"

step "Installing xbar..."
brew install --cask xbar
open -a xbar || true

# Configure xbar.
XBAR_PLUGINS_FOLDER="${HOME}/Library/Application Support/xbar/plugins"
mkdir -p "$XBAR_PLUGINS_FOLDER" || true

step "Getting dolar-blue plugin"
git clone git@github.com:inakiabt/dolar-bitbar-plugin.git ~/src/personal/dolar-bitbar-plugin

step "Setting up meta-package-bar plugin"
cp "$(mpm --bar-plugin-path)" "${XBAR_PLUGINS_FOLDER}/"

step "Making all plugins executable"
chmod +x "${XBAR_PLUGINS_FOLDER}"/*.{sh,rb,py} 2>/dev/null || true
