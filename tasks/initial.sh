#!/bin/bash

source "$DOTFILES/lib/task.sh"

if [ ! -f "$DOTFILES/.initial-setup-completed" ]; then
  read -rp "Please enter you 1Password account (example: account.1password.com): " ONEPASSWORD_ACCOUNT;
  read -rp "Please enter you 1Password email: " ONEPASSWORD_EMAIL;

  echo "{\"date\":\"$(date +%s)\",\"1password\":{\"account\":\"$ONEPASSWORD_ACCOUNT\",\"email\":\"$ONEPASSWORD_EMAIL\"}}" | jq -r > "$DOTFILES/.initial-setup-completed"
fi

if [ ! -f "$HOME/.ssh/config" ]; then
  step "Setup initial SSH config"
  mkdir_step "$HOME/.ssh"
  cp "$DOTFILES/files/.ssh/config" "$HOME/.ssh/config"
fi

if [ ! -f "$HOME/.config/git/config" ]; then
  mkdir -p "$HOME/.config/git"
  cp "$DOTFILES/files/.config/git/config" "$HOME/.config/git/config"
fi
