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
