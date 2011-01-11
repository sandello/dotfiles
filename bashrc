[ -z "$PS1" ] && return

export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
export HISTCONTROL=ignoreboth

shopt -s histappend
shopt -s checkwinsize

case "$TERM" in
    xterm) color_prompt=yes;;
    xterm-color) color_prompt=yes;;
esac

if [ "$color_prompt" = yes ]; then
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='\u@\h:\w\$ '
fi
unset color_prompt

case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

if [ -d ~/bin ]; then
    PATH=$PATH:~/bin
fi

if [ -d ~/.local/bin ]; then
    PATH=$PATH:~/.local/bin
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.bash_aliases_private ]; then
    . ~/.bash_aliases_private
fi

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

function reload() {
    . ~/.bashrc
}

export EDITOR=vim
export TMPDIR=/var/tmp

export PATH=/opt/local/bin:/opt/local/sbin:$PATH

