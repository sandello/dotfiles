#!/usr/bin/env zsh

for ITEM in $HOME/.{aliases,aliases_private,exports,exports_private}; do
    [[ -f "$ITEM" ]] && source "$ITEM"
done
unset ITEM

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE="65536"

# http://zsh.sourceforge.net/Doc/Release/Options.html
setopt NO_BEEP
setopt NO_FLOW_CONTROL
setopt PROMPT_SUBST
setopt LOCAL_OPTIONS
setopt LOCAL_TRAPS
setopt COMPLETE_IN_WORD
setopt INTERACTIVE_COMMENTS
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt HIST_EXPIRE_DUPS_FIRST
setopt LONG_LIST_JOBS

# zinit.
if [[ -d "$HOME/.zinit/bin" ]]; then
    source "$HOME/.zinit/bin/zinit.zsh"

    # Install p10k prompt.
    zinit ice lucid
    zinit light romkatv/powerlevel10k
    # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

    zinit wait lucid for \
        atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
        zdharma/fast-syntax-highlighting \
        wookayin/fzf-fasd
fi

# fzf integration.
if [[ -d /usr/local/opt/fzf/shell ]]; then
    source /usr/local/opt/fzf/shell/completion.zsh
    source /usr/local/opt/fzf/shell/key-bindings.zsh
else
    bindkey "^R" history-incremental-search-backward
fi

# fasd integration.
if [[ $commands[fasd] ]]; then
    fasd_cache="${ZSH_CACHE_DIR}/fasd-init-cache"
    if [[ ! -s "$fasd_cache" ]]; then
        fasd --init posix-alias zsh-hook \
            zsh-ccomp zsh-ccomp-install \
            zsh-wcomp zsh-wcomp-install >| "$fasd_cache"
    fi
    source "$fasd_cache"
    unset fasd_cache
fi

# iterm2 integration.
if [[ -f "$HOME/.dotfiles/zsh/iterm2.zsh" ]]; then
    source "$HOME/.dotfiles/zsh/iterm2.zsh"
fi

#autoload -U up-line-or-beginning-search
#autoload -U down-line-or-beginning-search
autoload -U edit-command-line

#zle -N up-line-or-beginning-search
#zle -N down-line-or-beginning-search
zle -N edit-command-line

bindkey "^V" edit-command-line

autoload -U compinit
compinit

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
