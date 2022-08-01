#!/usr/bin/env bash

set -Eeuo pipefail

SOURCE="git@github.com:inakiabt/dotfiles.git"
TARGET="$HOME/.dotfiles"

echo "Welcome to the dotfiles installer!"
echo "=================================="
echo "This script will clone the dotfiles repository to your home directory."
echo "Let's start!"
sudo -v

while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

if test ! "$(which brew)"; then
  echo "Setup homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
if ! brew list git > /dev/null 2>&1; then
  echo "Install git"
  brew install git
fi

git --version
# Add brew sbin to the `$PATH`
export PATH="/usr/local/sbin:$PATH"

# Add brew bin to the `$PATH`
export PATH="/usr/local/bin:$PATH"

echo "Installing dotfiles..."
mkdir -p "$TARGET"
git clone $SOURCE "$TARGET"

read -rp "Are you ready to run the setup? (y/n) " -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
  cd "$TARGET" || exit 1
  sh setup.sh
else
  echo "Once you are ready, run:"
  echo "cd $TARGET"
  echo "sh setup.sh"
fi