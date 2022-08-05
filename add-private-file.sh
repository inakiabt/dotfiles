#!/bin/bash
set -Eeuo pipefail

CURRENT_DOTFILES=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$CURRENT_DOTFILES/config.sh"
if [ "$CURRENT_DOTFILES" != "$DOTFILES" ]; then
  echo "Error: The current dotfiles directory is not the same as the one in the config file."
  echo "Current: $CURRENT_DOTFILES"
  echo "Config: $DOTFILES"
  exit 1
fi

source "$DOTFILES/lib/exports.sh"
source "$DOTFILES/lib/args.sh"

NAME="$1"
FILE="$2"
VAULT="${3:-Private}"

echo "Adding file $FILE ($NAME) to vault $VAULT"
DESTINATION_PATH="$(realpath --relative-to="$HOME" "$FILE")"
if [ $? -eq 1 ]; then
  echo "File must be part of $HOME. Aborting."
  exit 1
fi

# check if FILE exists
if [ ! -f "$FILE" ]; then
  echo "File does not exist. Aborting."
  exit 1
fi

DESTINATION_PATH="$(realpath --relative-to="$HOME" "$FILE")"
FILENAME="$(basename "$FILE")"

DOCUMENT_ID=$(op document create "$FILE" --title "$NAME" --file-name "$FILENAME" --vault "$VAULT" --tags dotfiles,document | jq -r '.uuid')
echo "Document ID: $DOCUMENT_ID"
op item edit "$DOCUMENT_ID" "path[text]=$DESTINATION_PATH"
echo "DONE"
