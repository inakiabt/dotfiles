#!/bin/bash

source "$DOTFILES/lib/task.sh"

if [ ! -d "$DOTFILES/mackup" ]; then
  step "Checkout private mackup repository..."
  git clone "personal:$DOTFILES_MACKUP_REPO.git" "$DOTFILES/mackup"
else
  step "Updating private mackup repository..."
  mackup_git pull
fi

symlink "$MACKUP/.mackup.cfg" "$HOME/.mackup.cfg"
symlink "$MACKUP/.mackup" "$HOME/.mackup"

step "Installing mackup..."
brew install mackup

# Restore mackup files.
step "Mackup restore (dry run):"
mackup -n restore
echo ""
read -rp "Are you sure you want to proceed? (y/n) " -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
  mackup restore
else
  exit 0
fi
