#!/bin/bash

source "$DOTFILES/lib/task.sh"

if [ -f "$DOTFILES/.initial-setup-completed" ]; then
  read -rp "Please enter you 1Password account (example: account.1password.com): " ONEPASSWORD_ACCOUNT;
  read -rp "Please enter you 1Password email: " ONEPASSWORD_EMAIL;

  echo "{\"date\":\"$(date +%s)\",\"1password\":{\"account\":\"$ONEPASSWORD_ACCOUNT\",\"email\":\"$ONEPASSWORD_EMAIL\"}}" | jq -r > "$DOTFILES/.initial-setup-completed"
fi

if [ ! -f "$HOME/Library/LaunchAgents/com.1password.SSH_AUTH_SOCK.plist" ]; then
  mkdir -p "$HOME/Library/LaunchAgents"
  cp "$DOTFILES/files/com.1password.SSH_AUTH_SOCK.plist" "$HOME/Library/LaunchAgents/"
  launchctl load -w "$HOME/Library/LaunchAgents/com.1password.SSH_AUTH_SOCK.plist" || true
fi

if [ ! -f "$HOME/.ssh/config" ]; then
  mkdir -p "$HOME/.ssh"
  cp "$DOTFILES/files/.ssh/config" "$HOME/.ssh/config"
fi

if [ ! -f "$HOME/.config/git/config" ]; then
  mkdir -p "$HOME/.config/git"
  cp "$DOTFILES/files/.config/git/config" "$HOME/.config/git/config"
fi
