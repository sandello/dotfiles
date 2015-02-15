# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.

# Possibly Good Ones:
#  * prose
#  * daveverwer
#  * kennethreitz
#  * duellj
#  * jonathan
export ZSH_THEME="prose"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want disable red dots displayed while waiting for completion
# DISABLE_COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(osx git ruby brew)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

for item in $HOME/.{aliases,aliases_private,exports,exports_private}; do
    [ -f "$item" ] && \
        source "$item"
done
unset item

compdef g=git

compdef _git ga=git-add
compdef _git gai=git-add

compdef _git gb=git-branch
compdef _git gba=git-branch

compdef _git gc=git-commit

compdef _git gco=git-checkout

compdef _git gd=git-diff
compdef _git gdc=git-diff

compdef _git gs=git-status
compdef _git gst=git-status

compdef _git glg=git-log
compdef _git gLg=git-log
compdef _git gll=git-log
compdef _git gLL=git-log

compdef _git gl=git-pull
compdef _git gp=git-push

which -s dircolors > /dev/null 2>&1 && \
    eval $(dircolors $HOME/.dotfiles/dircolors-solarized/dircolors.256dark)

[[ -s "/etc/profile.d/rvm.sh" ]] && source "/etc/profile.d/rvm.sh"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
