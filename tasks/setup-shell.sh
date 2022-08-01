#!/bin/bash

source "$DOTFILES/lib/task.sh"

# Switch to using brew-installed bash as default shell
step "Checking if bash is the default shell..."
if ! grep -Fq '/usr/local/bin/bash' /etc/shells; then
  echo "Switching to bash shell"
  echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
  chsh -s /usr/local/bin/bash;
fi;
