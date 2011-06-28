system=$(uname -s)

case $(uname -s) in
    Linux*)
        if [ -x /usr/bin/dircolors ]; then
            test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

            alias ls='ls --color=auto'
            alias dir='dir --color=auto'
            alias vdir='vdir --color=auto'

            alias grep='grep --color=auto'
            alias fgrep='fgrep --color=auto'
            alias egrep='egrep --color=auto'
        fi

        if [ "x$DISPLAY" != "x" ]; then
            alias vim='gvim'
        fi
        ;;
    Darwin*)
        alias ls='ls -FG'

        if [ "x$DISPLAY" != "x" ]; then
            alias vim='mvim'
        fi
        ;;
esac

alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

alias gen_hg="dd if=/dev/urandom of=/dev/stdout bs=1024 count=4 2> /dev/null | md5sum - | cut -c 1-16"

alias tawk="awk -v FS='\t' -v OFS='\t'"

alias win2utf="iconv -f cp1251 -t utf-8"
alias utf2win="iconv -f utf-8 -t cp1251"

declare_directory_switch() {
    local name="$1"
    local target="$2"

    eval "
$name() {
    cd $target/\$*
}

_$name() {
    local current=\"\${COMP_WORDS[COMP_CWORD]}\"
    local variants=\$(_complete_directory_switch \"$target\" \"\$current\")
    COMPREPLY=(\$(compgen -W \"\$variants\" \"\$current\"))
}
complete -F _$name $name
"
}

_complete_directory_switch() {
    local path=$(cd "$1" && pwd -P)
    local name=$(echo "$2")
    local mydirname=$(dirname "$name")
    local mybasename=$(basename "$name")

    if [[ "z$mydirname" = "z." ]] ; then
        local variants=$(
            find "$path" -maxdepth 2 -path "$path/$name*" -type d \
            | egrep -v "\.(git|svn)" \
            | sed "s#$path/##;s#/*\$#/#"
        )
    else
        local variants=$(
            find "$path/$mydirname" -maxdepth 2 -path "$path/$mydirname/$mybasename*" -type d \
            | egrep -v "\.(git|svn)" \
            | sed "s#$path/##;s#/*\$#/#"
        )
    fi

    echo $variants
}

