#!/bin/bash

source "$DOTFILES/lib/task.sh"
source "$DOTFILES/lib/git.sh"

if [ "$(dotfiles_git remote -v | grep -c "personal:$DOTFILES_REPO.git")" -eq "0" ]; then
  step "Updating dotfiles origin"
  dotfiles_git remote set-url origin "personal:$DOTFILES_REPO.git"
fi
