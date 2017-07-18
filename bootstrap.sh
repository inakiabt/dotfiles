#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

# source .functions.d/ssh-config.bash
# ssh_config_hosts > .ssh/hosts.config
# ssh_config_generate > .ssh/config

function doIt() {
	rsync --exclude ".git/" --exclude ".gitmodules" --exclude ".DS_Store" --exclude "bootstrap.sh" \
		--exclude "README.md" --exclude ".ssh/" --exclude "LICENSE-MIT.txt" -av --no-perms . ~
	rsync -av --no-perms ./.ssh/* ~/.ssh
	source ~/.bash_profile
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	echo;
	echo "DRY RUN:"

	rsync --dry-run --exclude ".git/" --exclude ".gitmodules" --exclude ".DS_Store" --exclude "bootstrap.sh" \
		--exclude "README.md" --exclude ".ssh/" --exclude "LICENSE-MIT.txt" -av --no-perms . ~
	rsync --dry-run -av --no-perms ./.ssh/* ~/.ssh

	echo;
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
