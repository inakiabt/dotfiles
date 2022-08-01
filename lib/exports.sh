export CONFIG_FOLDER="$HOME/.config"
export DOTFILES="$HOME/.dotfiles"
export MACKUP="$DOTFILES/mackup"
export PATH="$PATH:$HOME/.local/bin"

# Check if SIP is going to let us mess with some part of the system.
SIP_DISABLED=$(csrutil status | grep --quiet "enabled"; echo $?)
export SIP_DISABLED
