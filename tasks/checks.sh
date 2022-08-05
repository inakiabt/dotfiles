#!/bin/bash

source "$DOTFILES/lib/task.sh"

# Detect platform.
if [ "$(uname -s)" != "Darwin" ]; then
  step "These dotfiles only targets macOS."
  exit 1
fi
