#!/bin/bash

source "$DOTFILES/lib/task.sh"

mpm --verbosity INFO cleanup
brew services cleanup
