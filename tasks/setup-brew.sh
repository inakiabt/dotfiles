#!/bin/bash

source "$DOTFILES/lib/task.sh"

# Check if homebrew is already installed. See: https://unhexium.net/zsh/how-to-check-variables-in-zsh/
# This also install xcode command line tools.
step "Checking if homebrew is installed"
if test ! "$(which brew)"; then
  substep "Installing homebrew..."
  # Install Homebrew without prompting for user confirmation.
  # See: https://github.com/Homebrew/install/pull/139
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  substep "Homebrew is already installed."
fi

step "Enabling analytics"
brew analytics on

# Refresh our local copy of package index.
step "Updating homebrew..."
brew update

# Fetch latest packages.
step "Upgrading homebrew..."
brew upgrade

step "Installing homebrew required packages..."
brew tap homebrew/bundle
brew install bash mas jq gettext git coreutils
brew install --cask 1password
brew install --cask 1password/tap/1password-cli
