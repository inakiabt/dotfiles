#!/bin/bash

[ ! "$IS_DOTFILES_RUN" == "true" ] && echo "Please run this script from the dotfiles repo root." && exit 1

function create_ssh_profile() {
  local name="$1"
  local host="$2"
  local git="$1"
  if [ -z "$host" ]; then
    local host="$name"
    local git="git@github.com"
  fi

  substep "Creating ssh profile into $CONFIG_FOLDER/ssh/profiles.d/$name"
  HOST="$host" GIT="$git" PROFILE="$name" /usr/local/bin/envsubst < "$DOTFILES/templates/ssh-profile.template" > "$CONFIG_FOLDER/ssh/profiles.d/$name"
}

function create_git_profile() {
  local name="$1"
  local profile="$2"
  local email="$3"
  local host="$4"
  local sign="${5:-false}"
  local key="$6"

  _create_git_profile "$name" "$profile" "$email" "$sign" "$key"
  if [ "$profile" = "personal" ]; then
    echo -e "[include]\\n  path = ~/.config/git/profiles.d/$name" >> "$CONFIG_FOLDER/git/profiles"
  else
    echo -e "[includeIf \"gitdir:~/src/$profile/$name/**\"]\\n  path = ~/.config/git/profiles.d/$name" >> "$CONFIG_FOLDER/git/profiles"
  fi
}

function _create_git_profile() {
  local name="$1"
  local profile="$2"
  local email="$3"
  local sign=${4:-false}
  local key="$5"

  [ "$profile" = "personal" ] && ALLOWED_SIGNERS_FOLDER="$profile" || ALLOWED_SIGNERS_FOLDER="$profile/$name"
  mkdir -p "$CONFIG_FOLDER/git/$ALLOWED_SIGNERS_FOLDER"

  substep "Setting up git profile into $CONFIG_FOLDER/git/profiles.d/$name"
  ALLOWED_SIGNERS_FOLDER="$ALLOWED_SIGNERS_FOLDER" SIGN_COMMITS="$sign" EMAIL="$email" SIGNING_KEY="$key" /usr/local/bin/envsubst < "$DOTFILES/templates/git-profile.template" > "$CONFIG_FOLDER/git/profiles.d/$name"

  substep "Add $email email as allowed signer ($CONFIG_FOLDER/git/$ALLOWED_SIGNERS_FOLDER/allowed_signers)"
  echo "$email $key" >> "$CONFIG_FOLDER/git/$ALLOWED_SIGNERS_FOLDER/allowed_signers"
}

function cleanup() {
  rm -f "$CONFIG_FOLDER/git/profiles.bkp"
}

function error() {
  [ -f "$CONFIG_FOLDER/git/profiles.bkp" ] && mv "$CONFIG_FOLDER/git/profiles.bkp" "$CONFIG_FOLDER/git/profiles"
  exit 1
}

function create_profile() {
  local name="$1"
  local profile="$2"
  local email="$3"
  local host="$4"
  local sign=${5:-false}
  local key="$6"

  step "Creating profile for $name ($profile)"
  substep "Saving into $HOME/.ssh/$name.pub"
  echo "$key" > "$HOME/.ssh/$name.pub"

  create_ssh_profile "$name" "$host"

  create_git_profile "$name" "$profile" "$email" "$host" "$sign" "$key"
}

mkdir -p "$CONFIG_FOLDER/ssh/profiles.d" || true
mkdir -p "$CONFIG_FOLDER/git/profiles.d" || true
