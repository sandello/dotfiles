# vim: set ft=sh:
function reload() {
    source "$HOME/.bash_profile"
}

shopt -s histappend
shopt -s checkwinsize
shopt -s nocaseglob

for item in $HOME/.{aliases,aliases_private,bash_prompt,exports,exports_private}; do
    [ -f "$item" ] && \
        source "$item"
done
unset item

[[ -f /etc/bash_completion ]] && source /etc/bash_completion

[[ -e $HOME/.ssh/config ]] && \
    complete -o default -o nospace -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh

which -s dircolors > /dev/null 2>&1 && \
    eval $(dircolors $HOME/.dotfiles/dircolors-solarized/dircolors.256dark)

[[ -s "/etc/profile.d/rvm.sh" ]] && source "/etc/profile.d/rvm.sh"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# The next line updates PATH for the Google Cloud SDK.
[[ -d "$HOME/google-cloud-sdk" ]] && source "$HOME/google-cloud-sdk/path.bash.inc"

# The next line enables bash completion for gcloud.
[[ -d "$HOME/google-cloud-sdk" ]] && source "$HOME/google-cloud-sdk/completion.bash.inc"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

[[ -f /etc/bash_completion ]] && source $HOME/.dotfiles/bash_completion_git

__git_complete ga _git_add
__git_complete gai _git_add

__git_complete gb _git_branch
__git_complete gba _git_branch

__git_complete gc _git_commit

__git_complete gco _git_checkout

__git_complete gd _git_diff
__git_complete gdc _git_diff

__git_complete glg _git_log
__git_complete gLg _git_log
__git_complete gll _git_log
__git_complete gLL _git_log

__git_complete gl _git_pull

__git_complete gp _git_push

