#!/bin/bash

source "$DOTFILES/lib/task.sh"
source "$DOTFILES/lib/keys.sh"

trap cleanup 0
trap error ERR

step "Getting default ssh profile from 1Password..."
while IFS="," read -r name profile email host sign key
do
  [ ! -d "$HOME/src/personal" ] && substep "Creating personal source code workspace in $HOME/src/personal" && mkdir -p "$HOME/src/personal"
  create_profile "$name" "$profile" "$email" "$host" "$sign" "$key"
done < <(op item list --tags ssh-default-profile --format json | op item get - --fields label=name,label=profile,label=email,label=host,label=sign-commits,label="public key")

step "Getting other profiles from 1Password..."
while IFS="," read -r name profile email host sign key
do
  [ ! -d "$HOME/src/$profile/$name" ] && substep "Creating source code workspace for $profile/$name in $HOME/src/$profile/$name" && mkdir -p "$HOME/src/$profile/$name"
  create_profile "$name" "$profile" "$email" "$host" "$sign" "$key"
done < <(op item list --tags ssh-profile --format json | op item get - --fields label=name,label=profile,label=email,label=host,label=sign-commits,label="public key")
