#!/bin/bash

source "$DOTFILES/lib/task.sh"

function restore_file() {
  local id="$1"
  local to="$2"

  substep "Restoring file $to..."
  op document get "$id" --output "$to" || true
}

function process_private_file() {
  local id="$1"

  substep "Getting $id from 1Password..."
  ITEM=$(op item get "$id" --format json)
  TITLE=$(echo "$ITEM" | jq -r '.title')
  FILE_NAME=$(echo "$ITEM" | jq -r '.files[0].name')
  DOCUMENT_PATH=$(echo "$ITEM" | jq -r '.fields[] | select(.label == "path") | .value')
  DOCUMENT_FILE_PATH="$DOCUMENT_PATH/$FILE_NAME"

  substep "Document \"$TITLE\" $DOCUMENT_FILE_PATH found"
  if [ -n "$DOCUMENT_FILE_PATH" ]; then
    DESTINATION_FOLDER="$HOME/$DOCUMENT_PATH"
    DESTINATION_FILE_PATH="$HOME/$DOCUMENT_FILE_PATH"

    if [ -f "$DESTINATION_FILE_PATH" ]; then
      [ "$ACCEPT_ENABLED" -eq "0" ] && read -rp "File already exist: \"$DESTINATION_FILE_PATH\". Are you sure you want to overwrite it? (y/n) " -n 1 && echo "" || REPLY="y";
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        if mv "$DESTINATION_FILE_PATH" "$DESTINATION_FILE_PATH.bak" && restore_file "$id" "$DESTINATION_FILE_PATH"; then
          rm -f "$DESTINATION_FILE_PATH.bak"
        else
          mv "$DESTINATION_FILE_PATH.bak" "$DESTINATION_FILE_PATH"
        fi
      else
        substep "Skipping..."
      fi
    elif [ ! -d "$DESTINATION_FOLDER" ]; then
      [ "$ACCEPT_ENABLED" -eq "0" ] && read -rp "The file destination folder does not exist: \"$DESTINATION_FOLDER\". Do you want to create it and continue? (y/n) " -n 1 && echo "" || REPLY="y";
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        mkdir -p "$DESTINATION_FOLDER"
        restore_file "$id" "$DESTINATION_FILE_PATH" || true
      fi
    else
      restore_file "$id" "$DESTINATION_FILE_PATH" || true
    fi
  else
    substep "Skipping item $TITLE because it has no path label configured"
  fi
}

step "Getting private files from 1Password..."
IDS=$(op item list --tags dotfiles,document --format json | jq -r '.[].id')
for ID in $IDS; do
  process_private_file "$ID"
done
