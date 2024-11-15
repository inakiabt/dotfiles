#!/usr/bin/env bash

# PIPETHIS_AUTHOR inakiabt

set -Eeuo pipefail

SOURCE="keybase://private/inakiabt/dotfiles"
TARGET="$HOME/.dotfiles"

echo "Welcome to the dotfiles installer!"
echo "=================================="
echo "This script will clone the dotfiles repository to your home directory."
echo "Let's start!"
sudo -v

while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

if test ! "$(which brew)"; then
  echo "Setting up homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$($(which brew) shellenv)"

if ! brew list git > /dev/null 2>&1; then
  echo "Installing git..."
  brew install git
fi
if ! brew list keybase > /dev/null 2>&1; then
  echo "Installing keybase..."
  brew install --cask keybase
fi

if ! keybase whoami; then
  echo "Login to keybase"
  keybase login
fi

echo "Git version"
git --version

if [ ! -d "$TARGET" ]; then
  echo "Installing dotfiles..."
  mkdir -p "$TARGET"
  git clone $SOURCE "$TARGET"
  cd "$TARGET"
  git config pull.rebase true
else
  echo "Updating dotfiles..."
  cd "$TARGET"
  git pull
fi

read -rp "Are you ready to run the setup? (y/n) " -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
  cd "$TARGET" || exit 1
  sh setup.sh
else
  echo "Once you are ready, run:"
  echo "sh $TARGET/setup.sh"
fi
