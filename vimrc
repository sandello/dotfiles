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

set hidden

set backup
set backupdir=~/.vim/backup
set directory=~/.vim/tmp

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

if isdirectory("/usr/local/opt/fzf")
	set rtp+=/usr/local/opt/fzf
	nnoremap <c-p> :FZF<cr>
endif

if isdirectory(expand("$HOME/.vim/bundle/Vundle.vim"))
	set rtp+=~/.vim/bundle/Vundle.vim

	call vundle#begin()

	Plugin 'VundleVim/Vundle.vim'
	Plugin 'Shougo/vimproc.vim'

	Plugin 'vim-airline/vim-airline'
	Plugin 'vim-airline/vim-airline-themes'
	let g:airline_theme = 'tomorrow'
	let g:airline_powerline_fonts = 1

	Plugin 'aaronjensen/vitality.vim'
	let g:vitality_fix_focus = 1
	let g:vitality_fix_cursor = 0

	Plugin 'derekwyatt/vim-fswitch'
	nmap <silent> <leader>A :FSHere<cr>

	Plugin 'nathanaelkane/vim-indent-guides'

	Plugin 'plasticboy/vim-markdown'

	Plugin 'scrooloose/nerdcommenter'

	Plugin 'scrooloose/nerdtree'
	nmap <F2> :NERDTreeToggle<cr>

	Plugin 'scrooloose/syntastic'
	let g:syntastic_always_populate_loc_list = 1
	let g:syntastic_auto_loc_list = 0
	let g:syntastic_check_on_open = 0
	let g:syntastic_check_on_wq = 0
	let g:syntastic_python_flake8_args = '--max-line-length=114'
	nmap <leader>s :SyntasticToggleMode<CR>

	Plugin 'tpope/vim-fugitive'

	Plugin 'ervandew/supertab'

	Plugin 'sirver/ultisnips'
	let g:UltiSnipsExpandTrigger = '<c-l>'
	let g:UltiSnipsJumpForwardTrigger = '<c-j>'
	let g:UltiSnipsJumpBackwardTrigger = '<c-k>'

	Plugin 'fatih/vim-go'
	au FileType go nmap <leader>s  <Plug>(go-implements)
	au FileType go nmap <leader>i  <Plug>(go-info)
	au FileType go nmap <leader>gd <Plug>(go-doc)
	au FileType go nmap <leader>gv <Plug>(go-doc-vertical)
	au FileType go nmap <leader>r  <Plug>(go-run)
	au FileType go nmap <leader>b  <Plug>(go-build)
	au FileType go nmap <leader>t  <Plug>(go-test)
	au FileType go nmap <leader>c  <Plug>(go-coverage)
	au FileType go nmap <leader>ds <Plug>(go-def-split)
	au FileType go nmap <leader>dv <Plug>(go-def-vertical)
	au FileType go nmap <leader>dt <Plug>(go-def-tab)
	au FileType go nmap <leader>e  <Plug>(go-rename)

	" Plugin 'Valloric/YouCompleteMe'
	" let g:ycm_autoclose_preview_window_after_completion = 1
	" let g:ycm_min_num_identifier_candidate_chars = 3
	" let g:ycm_semantic_triggers = {'haskell' : ['.']}
	" au FileType c,cpp nnoremap <leader>c :YcmForceCompileAndDiagnostics<cr>
	" au FileType c,cpp nnoremap <leader>g :YcmCompleter GoTo<cr>
	" au FileType c,cpp nnoremap <leader>d :YcmCompleter GoToDeclaration<cr>
	" au FileType c,cpp nnoremap <leader>D :YcmCompleter GoToDefinition<cr>
	" au FileType c,cpp nnoremap <leader>t :YcmCompleter GetType<cr>

	call vundle#end()
endif

set completeopt=menu,menuone,longest
set wildmode=list:longest,list:full

filetype plugin on
filetype indent on

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
	set guifont=JetBrains Mono:h13
endif

function! ToggleSemicolonHighlighting()
	if exists("b:semicolon")
		unlet b:semicolon
		hi semicolon guifg=NONE gui=NONE ctermfg=NONE
	else
		syn match semicolon #;\s*$#
		hi semicolon guifg=red gui=bold ctermfg=1
		let b:semicolon = 1
	endif
endfunction

function! EnableAutosave()
	autocmd CursorHold * silent update
	autocmd CursorHoldI * silent update
endfunction

nmap <silent> <leader>; :call ToggleSemicolonHighlighting()<cr>
vmap <silent> <leader>s !sort<cr>

map <c-n> :cnext<cr>
map <c-m> :cprevious<cr>
nnoremap <leader>x :cclose<cr>

au BufNewFile,BufRead *.c* call ToggleSemicolonHighlighting()
au BufNewFile,BufRead *.h* call ToggleSemicolonHighlighting()

au BufEnter * :sy sync fromstart
