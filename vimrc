" vim: set noet:

set cpo=aABceFsmq
set cpo&vim

let mapleader='\'

set backspace=indent,eol,start
set cinoptions=:s,g0,(s,ls

set shiftwidth=4
set tabstop=4
set textwidth=120
set colorcolumn=81
set expandtab

set encoding=utf-8
set termencoding=utf-8
set fileencodings=utf-8,cp1251,koi8-r,latin1

set nocompatible
set noerrorbells
set hlsearch
set incsearch
set ruler
set number

set wildignore=*.o
set viminfo='20,<50,s10,h

set backup
set backupdir=~/.vim/backup
set directory=~/.vim/tmp

set autochdir
set hidden

" Create directories, if required.
if !isdirectory(expand("$HOME/.vim/backup"))
	call mkdir(expand("$HOME/.vim/backup"), "p", 0700)
endif
if !isdirectory(expand("$HOME/.vim/tmp"))
	call mkdir(expand("$HOME/.vim/tmp"), "p", 0700)
endif

syntax on
set t_Co=256
set t_Sb=^[4%dm
set t_Sf=^[3%dm

filetype off

set rtp+=~/.fzf

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'tpope/vim-fugitive'
Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'Valloric/YouCompleteMe'
Bundle 'scrooloose/syntastic'
Bundle 'sirver/ultisnips'
Bundle 'derekwyatt/vim-fswitch'
Bundle 'aaronjensen/vitality.vim'
Bundle 'mileszs/ack.vim'
Bundle 'fatih/vim-go'
Bundle 'PeterRincker/vim-argumentative'

set completeopt=menu,menuone,longest
set wildmode=list:longest,list:full

filetype plugin on
filetype indent on

function! ToggleSemicolonHighlighting() " {{{
	if exists("b:semicolon")
		unlet b:semicolon
		hi semicolon guifg=NONE gui=NONE ctermfg=NONE
	else
		syn match semicolon #;\s*$#
		hi semicolon guifg=red gui=bold ctermfg=1
		let b:semicolon = 1
	endif
endfunction
" }}}

function! EnableAutosave()
	autocmd CursorHold * silent update
	autocmd CursorHoldI * silent update
endfunction

nmap <silent> <leader>; :call ToggleSemicolonHighlighting()<cr>
vmap <silent> <leader>s !sort<cr>

nnoremap <leader>a :A<cr>
nnoremap <leader>A :AV<cr>

nmap <F2> :NERDTreeToggle<cr>
nmap <F8> :make<cr>

if has("autocmd")
	au BufNewFile,BufRead *.c* call ToggleSemicolonHighlighting()
	au BufNewFile,BufRead *.h* call ToggleSemicolonHighlighting()
	au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif
	au BufEnter * :sy sync fromstart

	au FileType go nmap <leader>s <Plug>(go-implements)
	au FileType go nmap <leader>i <Plug>(go-info)
	au FileType go nmap <leader>gd <Plug>(go-doc)
	au FileType go nmap <leader>gv <Plug>(go-doc-vertical)
	au FileType go nmap <leader>r <Plug>(go-run)
	au FileType go nmap <leader>b <Plug>(go-build)
	au FileType go nmap <leader>t <Plug>(go-test)
	au FileType go nmap <leader>c <Plug>(go-coverage)
	au FileType go nmap <leader>ds <Plug>(go-def-split)
	au FileType go nmap <leader>dv <Plug>(go-def-vertical)
	au FileType go nmap <leader>dt <Plug>(go-def-tab)
	au FileType go nmap <leader>e <Plug>(go-rename)

	au FileType c,cpp nnoremap <leader>jc :YcmForceCompileAndDiagnostics<cr>
	au FileType c,cpp nnoremap <leader>jg :YcmCompleter GoTo<cr>
	au FileType c,cpp nnoremap <leader>jd :YcmCompleter GoToDeclaration<cr>
	au FileType c,cpp nnoremap <leader>jD :YcmCompleter GoToDefinition<cr>
	au FileType c,cpp nnoremap <leader>jt :YcmCompleter GetType<cr>
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

" Color Scheme
colorscheme Tomorrow-Night-Eighties

" GUI features
if (&termencoding == "utf-8") || has("gui_running")
	set list listchars=tab:»·,trail:·,extends:…
else
	set list listchars=tab:>-,trail:.,extends:>
endif

if has("gui_running")
	set background=light
	colorscheme solarized

	set gfn=Menlo\ Regular:h12
	set gfw=Menlo\ Regular:h12

	set columns=120
	set lines=48

	set cursorline

	set transparency=5
else
	set background=dark
	if !empty(globpath(&rtp, 'colors/hybrid.vim'))
		colorscheme hybrid
	endif
endif

" ack
let g:ackprg = "ag --vimgrep"

" fswitch
nmap <silent> <leader>A :FSHere<cr>

" vitality
let g:vitality_fix_focus = 1
let g:vitality_fix_cursor = 0

" argumentative
nmap <; <Plug>Argumentative_MoveLeft
nmap >; <Plug>Argumentative_MoveRight

" YouCompleteMe
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_min_num_identifier_candidate_chars = 3
let g:ycm_extra_conf_globlist = ['~/yt/*']

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_python_flake8_args = '--max-line-length=114'

let g:UltiSnipsExpandTrigger = '<c-l>'
let g:UltiSnipsJumpForwardTrigger = '<c-j>'
let g:UltiSnipsJumpBackwardTrigger = '<c-k>'

nnoremap <c-p> :FZF<cr>
