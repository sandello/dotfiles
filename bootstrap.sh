#!/bin/bash
################################################################################
# Based on: https://github.com/gf3/dotfiles/blob/master/bootstrap.sh
################################################################################

function notice {
  echo "\033[1;32m=> $1\033[0m"
}

function error {
  echo "\033[1;31m=> Error: $1\033[0m"
}

function c_list {
  echo "  \033[1;32m+\033[0m $1"
}

function e_list {
  echo "  \033[1;31m-\033[0m $1"
}

function dep {
  # Check whether package is installed
  local i=true
  type -p $1 &> /dev/null || i=false

  # Check package version
  if $i ; then
    local version=$($1 --version | grep -oE -m 1 "[[:digit:]]+\.[[:digit:]]+\.?[[:digit:]]?")
    [[ $version < $2 ]] && local msg="$1 version installed: $version, version needed: $2"
  else
    local msg="Missing $1"
  fi
  
  # Save if dependency is not met
  if ! $i || [ -n "$msg" ] ; then
    missing+=($msg)
  fi
}

################################################################################

current_pwd=$(pwd)
missing=()

set -e

notice "Checking dependencies..."
dep "git" "1.7"
dep "vim" "7.3"
dep "ruby" "1.8"

if [ "${#missing[@]}" -gt "0" ]; then
  error "Missing dependencies"
  for need in "${missing[@]}"; do
    e_list "$need."
  done
  exit 1
fi

if [ -d ~/.dotfiles ]; then
  notice "Updating..."

  cd ~/.dotfiles
  git pull origin master
  git submodule init
  git submodule update
else
  notice "Downloading..."

  git clone --recursive git://github.com/sandello/dotfiles.git ~/.dotfiles
  cd ~/.dotfiles
fi

notice "Installing..."
rake install

cd $current_pwd
notice "Done!"

