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

alias w2u="iconv -f cp1251 -t utf-8"
alias u2w="iconv -f utf-8 -t cp1251"

alias f="find . -iname"
alias g="grep -i"
