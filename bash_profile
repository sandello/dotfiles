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

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

[ -e "$HOME/.ssh/config" ] && \
    complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh


complete -o default -o nospace -F _git_add ga
complete -o default -o nospace -F _git_add gai

complete -o default -o nospace -F _git_branch gb
complete -o default -o nospace -F _git_branch gba

complete -o default -o nospace -F _git_commit gc

complete -o default -o nospace -F _git_checkout gco

complete -o default -o nospace -F _git_diff gd
complete -o default -o nospace -F _git_diff gdc

complete -o default -o nospace -F _git_status gs
complete -o default -o nospace -F _git_status gst

complete -o default -o nospace -F _git_log glg
complete -o default -o nospace -F _git_log gLg
complete -o default -o nospace -F _git_log gll
complete -o default -o nospace -F _git_log gLL

complete -o default -o nospace -F _git_pull gl
complete -o default -o nospace -F _git_push gp

source $HOME/.dotfiles/bash_completion_knife
