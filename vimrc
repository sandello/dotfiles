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

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'mileszs/ack.vim'
Bundle 'tpope/vim-fugitive'
Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'scrooloose/nerdcommenter'
Bundle 'ervandew/supertab'
Bundle 'Valloric/YouCompleteMe'
Bundle 'scrooloose/syntastic'
Bundle 'derekwyatt/vim-fswitch'
Bundle 'Blackrush/vim-gocode'
Bundle 'aaronjensen/vitality.vim'

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

nmap <silent> <leader>; :call ToggleSemicolonHighlighting()<CR>
vmap <silent> <leader>s !sort<CR>

nnoremap <leader>a :A<CR>
nnoremap <leader>A :AV<CR>

nmap <F2> :NERDTreeToggle<CR>
nmap <F8> :make<CR>

if has("autocmd")
	au BufNewFile,Bufread *.c* call ToggleSemicolonHighlighting()
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

" Color Scheme
set background=light

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

" fswitch
nmap <silent> <Leader>A :FSHere<cr>

" vitality
let g:vitality_fix_focus = 1
let g:vitality_fix_cursor = 0

" SuperTab
let g:SuperTabDefaultCompletionType = "context"

" YouCompleteMe
nnoremap <leader>jc :YcmForceCompileAndDiagnostics<CR>
nnoremap <leader>jg :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>jd :YcmCompleter GoToDefinition<CR>
nnoremap <leader>jc :YcmCompleter GoToDeclaration<CR>

let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_min_num_identifier_candidate_chars = 3

let g:syntastic_always_populate_loc_list = 1
let g:ycm_extra_conf_globlist = ['~/yt/source/*']

