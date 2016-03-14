# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$HOME/.composer/vendor/bin:$PATH"

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Loads all my bash functions
for f in ~/.{functions,aliases}.d/*.bash; do
  . $f;
done
unset f

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# If set, and readline is being used, a user is given the opportunity to re-edit a failed history substitution.
shopt -s histreedit;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if which brew > /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
	source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
	complete -o default -o nospace -F _git g;
fi;

# Enable tab completion for `aws`
complete -C aws_completer aws

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall

# Add tab completion for git `g` alias
complete -o bashdefault -o default -o nospace -F _git g 2>/dev/null || complete -o default -o nospace -F _git g

# Autocomplete Grunt commands
which grunt > /dev/null && eval "$(grunt --completion=bash)"

[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh

source ~/profile.d/*

# Enable nvm
export NVM_DIR=~/.nvm
. $(brew --prefix nvm)/nvm.sh

# If possible, add tab completion for many more commands
if [ -f $(brew --prefix)/etc/bash_completion ]; then
. $(brew --prefix)/etc/bash_completion
fi

[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

[ -f ~/bin/bashmarks/bashmarks.sh ] && source ~/bin/bashmarks/bashmarks.sh

source /opt/boxen/homebrew/opt/autoenv/activate.sh

source '/opt/homebrew-cask/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc'
source '/opt/homebrew-cask/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc'
