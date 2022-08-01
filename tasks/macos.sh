#!/bin/bash

source "$DOTFILES/lib/task.sh"
set +Eeuo pipefail

step "Setting up macOS..."
if [[ ${SIP_DISABLED} -ne 0 ]]; then
    substep "System Integrity Protection (SIP) is disabled."
else
    substep "System Integrity Protection (SIP) is enabled."
fi

export SIP_DISABLED
source "$DOTFILES/macos.sh"
unset SIP_DISABLED

APPS_TO_CLOSE=("Activity Monitor" "Address Book" "Calendar" "cfprefsd" "Contacts" "Dock" "Finder" "Google Chrome Canary" "Google Chrome" "Mail" "Messages" "Opera" "Photos" "Safari" "SizeUp" "Spectacle" "SystemUIServer" "Transmission" "Tweetbot" "Twitter" "iCal")
step "We need to close the following apps";
echo "${APPS_TO_CLOSE[@]}"
read -rp "Are you sure you want to proceed? (y/n) " -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
  for app in "${APPS_TO_CLOSE[@]}"; do
    killall "${app}" &> /dev/null
  done
fi

step "Do not forget to restart this terminal once you finish with the setup 😉"
