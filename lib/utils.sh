#!/bin/bash

function step() {
  echo "⚡  $1"
}

function substep() {
  echo "  *  $1"
}

function symlink() {
  ([ "$1" -ef "$2" ] && return) || ln -s "$1" "$2"
}
