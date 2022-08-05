#!/bin/bash

[ ! "$IS_DOTFILES_RUN" == "true" ] && echo "Please run this script from the dotfiles repo root." && exit 1

function step() {
  echo "⚡  $1"
}

function substep() {
  echo "  *  $1"
}

function symlink() {
  ([ "$1" -ef "$2" ] && return) || ln -s "$1" "$2"
}

function mkdir_step() {
  local dir="$1"
  local message="${2:-"Creating $dir"}"
  [ ! -d "$dir" ] && step "$message" && mkdir -p "$dir" || true
}
