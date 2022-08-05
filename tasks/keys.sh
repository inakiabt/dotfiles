#!/bin/bash

source "$DOTFILES/lib/task.sh"
source "$DOTFILES/lib/keys.sh"

trap cleanup 0
trap error ERR

[ -f "$CONFIG_FOLDER/git/profiles" ] && mv "$CONFIG_FOLDER/git/profiles" "$CONFIG_FOLDER/git/profiles.bkp"

step "Getting default ssh profile from 1Password..."
while IFS="," read -r name profile email host sign key
do
  [ ! -d "$DOTFILES_SRC_PERSONAL_FOLDER" ] && substep "Creating personal source code workspace in $DOTFILES_SRC_PERSONAL_FOLDER" && mkdir -p "$DOTFILES_SRC_PERSONAL_FOLDER"
  create_profile "$name" "$profile" "$email" "$host" "$sign" "$key"
done < <(op item list --tags ssh-default-profile --format json | op item get - --fields label=name,label=profile,label=email,label=host,label=sign-commits,label="public key")

step "Getting other profiles from 1Password..."
while IFS="," read -r name profile email host sign key
do
  [ ! -d "$DOTFILES_SRC_FOLDER/$profile/$name" ] && substep "Creating source code workspace for $profile/$name in $DOTFILES_SRC_FOLDER/$profile/$name" && mkdir -p "$DOTFILES_SRC_FOLDER/$profile/$name"
  create_profile "$name" "$profile" "$email" "$host" "$sign" "$key"
done < <(op item list --tags ssh-profile --format json | op item get - --fields label=name,label=profile,label=email,label=host,label=sign-commits,label="public key")
