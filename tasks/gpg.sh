#!/bin/bash

source "$DOTFILES/lib/task.sh"

function ready_to_touchid() {
  security find-generic-password -s 'GnuPG' > /dev/null 2>&1 && return 0
  return 1
}

function passphrase_ask() {
  ready_to_touchid
  ret=$?
  if [ ! $ret -eq 0 ]; then
    step "Passphrase wasn't found"
    [ "$ACCEPT_ENABLED" -eq "0" ] && read -rp "Do you want to set it up now? (y/n) " -n 1 || REPLY="y";
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      return 1;
    fi
  fi
  return $ret;
}

step "Installing pinentry-mac && pinentry-touchid..."
brew tap jorgelbg/tap
brew install pinentry-mac pinentry-touchid

mkdir_step "$HOME/.gnupg"
if [ ! -f "$HOME/.gnupg/gpg-agent.conf" ]; then
  echo "pinentry-program /usr/local/bin/pinentry-mac" > "$HOME/.gnupg/gpg-agent.conf"
  defaults write org.gpgtools.common UseKeychain -bool yes
  gpgconf --kill gpg-agent > /dev/null 2>&1
  killall gpg-agent > /dev/null 2>&1 || true
  killall gpg2 > /dev/null 2>&1 || true
  killall gpg > /dev/null 2>&1 || true
  killall dirmngr > /dev/null 2>&1 || true
fi

step "Setup gpg key"
brew install --cask keybase
if ! keybase whoami; then
  step "Login to keybase"
  keybase login
  keybase pgp pull-private
fi

until passphrase_ask; do
  substep "You should see a dialog asking for your key passphrase. You have to check \"Save to Keychain\""
  echo 1234 | gpg -as - > /dev/null 2>&1 && ready_to_touchid && echo "Great! You can use touchid now" || echo "Oops! Something went wrong"
done

if ready_to_touchid; then
  PINENTRY_TOUCHID_BIN="$(brew --prefix pinentry-touchid)/bin/pinentry-touchid"
  if ! grep -q "^pinentry-program $PINENTRY_TOUCHID_BIN" "$HOME/.gnupg/gpg-agent.conf"; then
    pinentry-touchid -fix
    pinentry-touchid -check
    substep "Configuring pinentry-touchid"
    sed -i "/^pinentry-program .+$/pinentry-program $PINENTRY_TOUCHID_BIN/" "$HOME/.gnupg/gpg-agent.conf"
    gpg-connect-agent reloadagent /bye
    defaults write org.gpgtools.common DisableKeychain -bool yes
    defaults write org.gpgtools.common UseKeychain -bool no
  fi
fi
