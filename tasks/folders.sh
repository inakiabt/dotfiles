#!/bin/bash

source "$DOTFILES/lib/task.sh"

mkdir_step "$HOME/.config"
mkdir_step "$HOME/.config/ssh/profiles"
mkdir_step "$HOME/.ssh"
mkdir_step "$HOME/tmp" "Creating temp folder $HOME/tmp"
mkdir_step "$DOTFILES_SRC_FOLDER" "Creating source code workspace $DOTFILES_SRC_FOLDER"
