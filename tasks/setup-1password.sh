#!/bin/bash

source "$DOTFILES/lib/task.sh"

step "Ensure SSH_AUTH_SOCK is set for all apps"
# shellcheck disable=SC2143
[ -z "$(launchctl list | grep com.1password.SSH_AUTH_SOCK)" ] && launchctl load -w "$HOME/Library/LaunchAgents/com.1password.SSH_AUTH_SOCK.plist"

ONEPASSWORD_ACCOUNT=$(jq -r '."1password".account' "$DOTFILES/.initial-setup-completed")
ONEPASSWORD_EMAIL=$(jq -r '."1password".email' "$DOTFILES/.initial-setup-completed")

step "Ensure your 1Password account is set: $ONEPASSWORD_ACCOUNT ($ONEPASSWORD_EMAIL)"
if ! op account list | grep -q "$ONEPASSWORD_ACCOUNT"; then
  substep "We are going to open 1Password and set your account"
  echo ""
  echo "   👉 Once there, don't forget to turn on biometric unlock on 1Password:"
  echo "      1- Click the account or collection at the top of the sidebar and choose Preferences > Security."
  echo "      2- Select Touch ID."
  echo "      3- Click Developer in the sidebar."
  echo "      4- Select Biometric Unlock for 1Password CLI."
  echo ""
  echo "      # Note: https://developer.1password.com/docs/cli/get-started#turn-on-biometric-unlock"
  echo ""
  sleep 5
  open -a "1Password" || true
  [ "$ACCEPT_ENABLED" -eq "0" ] && read -n 1 -s -r -p "Press any key to continue" && echo ""
else
  step "Ensure you are signed in into 1Password"
  eval "$(op signin --account "$ONEPASSWORD_ACCOUNT")"
fi

step "Ensure 1Password is running the SSH agent"
if [ ! -S "$SSH_AUTH_SOCK" ]; then
  substep "You need to turn on the 1Password SSH Agent"
  echo "    1- Go to Preferences > Developer."
  echo "    2- Select the checkbox to \"Use the SSH agent\"."
  echo "    3- Optional: Select the checkbox to \"Display key names when authorizing connections\"."
  echo ""
  echo "    # Note: https://developer.1password.com/docs/ssh/get-started#step-3-turn-on-the-1password-ssh-agent"
  echo "";
  open -a "1Password" || true
  [ "$ACCEPT_ENABLED" -eq "0" ] && read -n 1 -s -r -p "Press any key to continue" && echo ""
fi
