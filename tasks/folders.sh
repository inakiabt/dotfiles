#!/bin/bash

source "$DOTFILES/lib/task.sh"

step "Creating ~/.config"
mkdir -p ~/.config
step "Creating ~/.config/ssh"
mkdir -p ~/.config/ssh/profiles
step "Creating ~/.config/ssh/profiles"
mkdir -p ~/.ssh
step "Creating ~/tmp"
mkdir -p ~/tmp
step "Creating ~/src"
mkdir -p ~/src
