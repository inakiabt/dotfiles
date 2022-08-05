#!/bin/bash

[ ! "$IS_DOTFILES_RUN" == "true" ] && echo "Please run this script from the dotfiles repo root." && exit 1

# Enable nvm
export NVM_DIR="$HOME/.nvm"
if [ -s "$(brew --prefix nvm)/nvm.sh" ]; then
  . "$(brew --prefix nvm)/nvm.sh" || true # This loads nvm
else
  echo "nvm is not installed. Aborting..."
  exit 1
fi
