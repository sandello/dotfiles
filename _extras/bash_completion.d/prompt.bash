#!/usr/bin/env bash

# Heavily inspired by @necolas’s prompt: https://github.com/necolas/dotfiles
# Heavily inspired by https://github.com/mathiasbynens/dotfiles/blob/master/.bash_prompt

if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
  export TERM="gnome-256color"
elif infocmp xterm-256color >/dev/null 2>&1; then
  export TERM="xterm-256color"
fi

prompt_git() {
  local s=""
  local b=""

  # Check if the current directory is in a Git repository.
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    # Check if the current directory is in .git before running git checks.
    if [ "$(git rev-parse --is-inside-git-dir 2>/dev/null)" == "false" ]; then

      # Ensure the index is up to date.
      git update-index --really-refresh -q &>/dev/null;

      # Check for uncommitted changes in the index.
      if ! git diff --quiet --ignore-submodules --cached >/dev/null 2>&1; then
        s+="+"
      fi

      # Check for unstaged changes.
      if ! git diff-files --quiet --ignore-submodules -- >/dev/null 2>&1; then
        s+="!"
      fi;

      # Check for untracked files.
      if [ -n "$(git ls-files --others --exclude-standard)" ]; then
        s+="?"
      fi

      # Check for stashed files.
      if git rev-parse --verify refs/stash >/dev/null 2>&1; then
        s+="$"
      fi
    fi

    # Get the short symbolic ref.
    # If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
    # Otherwise, just give up.
    b="$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2> /dev/null || echo "(unknown)")"

    if [ -n "${s}" ]; then
      s=" [${s}]"
    fi

    echo -e "${1}${b}${2}${s}"
  else
    return
  fi
}

if tput setaf 1 &> /dev/null; then
  tput sgr0 # reset colors
  bold=$(tput bold)
  reset=$(tput sgr0)
  # Solarized colors, taken from http://git.io/solarized-colors.
  black=$(tput setaf 0)
  blue=$(tput setaf 33)
  cyan=$(tput setaf 37)
  green=$(tput setaf 64)
  orange=$(tput setaf 166)
  purple=$(tput setaf 125)
  red=$(tput setaf 124)
  violet=$(tput setaf 61)
  white=$(tput setaf 15)
  yellow=$(tput setaf 136)
else
  bold=""
  reset="\e[0m"
  black="\e[1;30m"
  blue="\e[1;34m"
  cyan="\e[1;36m"
  green="\e[1;32m"
  orange="\e[1;33m"
  purple="\e[1;35m"
  red="\e[1;31m"
  violet="\e[1;35m"
  white="\e[1;37m"
  yellow="\e[1;33m"
fi

# Highlight the user name when logged in as root.
if [[ "${USER}" == "root" ]]; then
  userStyle="${red}"
else
  userStyle="${orange}"
fi

# Highlight the hostname when connected via SSH.
if [[ "${SSH_TTY}" ]]; then
  hostStyle="${bold}${red}"
else
  hostStyle="${yellow}"
fi

# Set the terminal title and prompt.
PS1="\[\033]0;\W\007\]" # working directory base name
PS1+="\[${bold}\]\n" # newline
PS1+="\[${userStyle}\]\u" # username
PS1+="\[${white}\] at "
PS1+="\[${hostStyle}\]\h" # host
PS1+="\[${white}\] in "
PS1+="\[${green}\]\w" # working directory full path
PS1+="\$(prompt_git \"\[${white}\] on \[${violet}\]\" \"\[${blue}\]\")" # git
PS1+="\n"
PS1+="\[${white}\]\$ \[${reset}\]" # `$` (and reset color)
export PS1

PS2="\[${yellow}\]→ \[${reset}\]"
export PS2