[ ! "$IS_DOTFILES_RUN" == "true" ] && echo "Please run this script from the dotfiles repo root." && exit 1

function mackup_git() {
  git --git-dir "$DOTFILES/mackup/.git" "$@"
}

function dotfiles_git() {
  git --git-dir "$DOTFILES/.git" "$@"
}
