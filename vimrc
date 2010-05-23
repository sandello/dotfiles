" vim: set noet:

set cpo=aABceFsmq
set cpo&vim

let mapleader='\'

set backspace=indent,eol,start

set shiftwidth=4
set tabstop=4
set textwidth=120
set expandtab

set background=dark

set encoding=utf-8
set termencoding=utf-8
set fileencodings=utf-8,cp1251,koi8-r,latin1

set nocompatible
set noerrorbells
set hlsearch
set incsearch
set ruler

set wildignore=*.o
set viminfo='20,<50,s10,h

set backup
set backupdir=~/.vim/backup
set directory=~/.vim/tmp

" Create directories, if required.
if !isdirectory("~/.vim/backup")
	call mkdir("~/.vim/backup", "p", 0700)
endif
if !isdirectory("~/.vim/tmp")
	call mkdir("~/.vim/tmp", "p", 0700)
endif

syntax on
set t_Co=8
set t_Sb=^[4%dm
set t_Sf=^[3%dm

filetype plugin on
filetype indent on

function! ToggleSemicolonHighlighting() " {{{
	if exists("b:semicolon")
		unlet b:semicolon
		hi semicolon guifg=NONE gui=NONE ctermfg=NONE
	else
		syn match semicolon #;$#
		hi semicolon guifg=red gui=bold ctermfg=1
		let b:semicolon = 1
	endif
endfunction
" }}}

nmap <silent> <leader>; :call ToggleSemicolonHighlighting()<CR>
vmap <silent> <leader>s !sort<CR>

map <F8> <ESC>:make<CR>

if has("autocmd")
	au BufNewFile,Bufread *.c*  call ToggleSemicolonHighlighting()
	au BufNewFile,Bufread *.h* call ToggleSemicolonHighlighting()
	au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif
	au BufEnter * :sy sync fromstart
endif

" Status line
set laststatus=2
set statusline=
set statusline+=%-3.3n\                    " Buffer number
set statusline+=%f\                        " File name
set statusline+=%h%m%r%w                   " Flags (help, modified, read-only, preview)
set statusline+=\[                         " Opening bracket
set statusline+=%{strlen(&ft)?&ft:'none'}, " File type
set statusline+=%{&encoding},              " Encoding
set statusline+=%{&fileformat}             " File format
set statusline+=\]\                        " Closing bracket
set statusline+=%=                         " Right align
set statusline+=%b\ /\ 0x%04B              " Current character (decimal / hexadecimal)
set statusline+=\ \ \ \                    " Padding
set statusline+=%-14.(%l,%c%V%)\ %<%P      " Offset

" Folding
set foldmethod=marker
set foldmarker={,}
set foldlevel=128
set foldopen=block,hor,mark,percent,quickfix,tag

" GUI features
if (&termencoding == "utf-8") || has("gui_running")
	set list listchars=tab:»·,trail:·,extends:…
else
	set list listchars=tab:>-,trail:.,extends:>
endif

if has("gui_running")
	colorscheme inkpot

	set gfn="Menlo 12"
	set gfw="Menlo 12"

	set columns=150
	set lines=50

	set cursorline

	set transparency=5
endif

