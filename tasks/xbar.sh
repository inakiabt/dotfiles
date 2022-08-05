#!/bin/bash

source "$DOTFILES/lib/task.sh"
source "$DOTFILES/lib/nvm.sh"

step "Installing xbar..."
brew install --cask xbar
open -a '/Applications/xbar.app' || true

# Configure xbar.
XBAR_PLUGINS_FOLDER="${HOME}/Library/Application Support/xbar/plugins"
mkdir_step "$XBAR_PLUGINS_FOLDER" || true

if [ ! -d "$DOTFILES_SRC_PERSONAL_FOLDER/dolar-bitbar-plugin" ]; then
  step "Getting dolar-blue plugin"
  git clone git@github.com:inakiabt/dolar-bitbar-plugin.git "$DOTFILES_SRC_PERSONAL_FOLDER/dolar-bitbar-plugin"
  cd "$DOTFILES_SRC_PERSONAL_FOLDER/dolar-bitbar-plugin" && npm install && cd - || true
fi

step "Setting up meta-package-bar plugin"
MPM_BAR_PLUGIN=$(mpm --bar-plugin-path)
cp -f "${MPM_BAR_PLUGIN/\~\//"$HOME/"}" "${XBAR_PLUGINS_FOLDER}/"

step "Making all plugins executable"
chmod +x "${XBAR_PLUGINS_FOLDER}"/*.{sh,rb,py} 2>/dev/null || true
