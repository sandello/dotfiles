" vim: set noet:

set cpo=aABceFsmq
set cpo&vim

let mapleader='\'

set backspace=indent,eol,start
set cinoptions=:s,g0,(s,ls

set shiftwidth=4
set tabstop=4
set textwidth=114
set colorcolumn=115
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
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

Plugin 'aaronjensen/vitality.vim'
Plugin 'derekwyatt/vim-fswitch'
Plugin 'ervandew/supertab'
Plugin 'fatih/vim-go'
Plugin 'mileszs/ack.vim'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'PeterRincker/vim-argumentative'
Plugin 'plasticboy/vim-markdown'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'Shougo/vimproc.vim'
Plugin 'sirver/ultisnips'
Plugin 'tpope/vim-fugitive'
Plugin 'Valloric/YouCompleteMe'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'VundleVim/Vundle.vim'

call vundle#end()

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

function! SetProjectRoot()
	lcd %:p:h
	let good_dir = fnamemodify(".", ":p:h")
	while 1
		lcd ..
		let git_dir = system("git rev-parse --show-toplevel")
		let is_not_git_dir = matchstr(git_dir, '^fatal:.*')
		if good_dir == git_dir
			break
		endif
		if empty(is_not_git_dir)
			let good_dir = git_dir
			lcd `=good_dir`
		else
			break
		endif
	endwhile
	lcd `=good_dir`
endfunction

nmap <silent> <leader>; :call ToggleSemicolonHighlighting()<cr>
vmap <silent> <leader>s !sort<cr>

nnoremap <leader>a :A<cr>
nnoremap <leader>A :AV<cr>

nmap <F2> :NERDTreeToggle<cr>

nnoremap <c-p> :FZF<cr>

map <c-n> :cnext<cr>
map <c-m> :cprevious<cr>
nnoremap <leader>x :cclose<cr>

if has("autocmd")
	au BufNewFile,BufRead *.c* call ToggleSemicolonHighlighting()
	au BufNewFile,BufRead *.h* call ToggleSemicolonHighlighting()

	au BufEnter * :sy sync fromstart
	au BufRead * call SetProjectRoot()

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

	au FileType c,cpp nnoremap <leader>c :YcmForceCompileAndDiagnostics<cr>
	au FileType c,cpp nnoremap <leader>g :YcmCompleter GoTo<cr>
	au FileType c,cpp nnoremap <leader>d :YcmCompleter GoToDeclaration<cr>
	au FileType c,cpp nnoremap <leader>D :YcmCompleter GoToDefinition<cr>
	au FileType c,cpp nnoremap <leader>t :YcmCompleter GetType<cr>
endif

" Status line
set laststatus=2

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
	set guifont=Source\ Code\ Pro:h12
endif

" airline
let g:airline_theme = "tomorrow"
let g:airline_powerline_fonts = 1

" ack
if executable('ag')
	let g:ackprg = 'ag --vimgrep'
endif

" fswitch
nmap <silent> <leader>A :FSHere<cr>
nmap <leader>s :SyntasticToggleMode<CR>

" vitality
let g:vitality_fix_focus = 1
let g:vitality_fix_cursor = 0

" argumentative
nmap <; <Plug>Argumentative_MoveLeft
nmap >; <Plug>Argumentative_MoveRight

" YouCompleteMe
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_min_num_identifier_candidate_chars = 3
let g:ycm_extra_conf_globlist = ['~/yt/*', '/yt/*']
let g:ycm_semantic_triggers = {'haskell' : ['.']}

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_python_flake8_args = '--max-line-length=114'

let g:UltiSnipsExpandTrigger = '<c-l>'
let g:UltiSnipsJumpForwardTrigger = '<c-j>'
let g:UltiSnipsJumpBackwardTrigger = '<c-k>'
