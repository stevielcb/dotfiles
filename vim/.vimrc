set encoding=utf-8
execute pathogen#infect()
set term=xterm-256color
filetype plugin indent on
syntax on

set hlsearch
set ts=2
set shiftwidth=2
set expandtab
set autoindent
set smartindent
set cindent
set mouse=a
set clipboard=unnamed
set ruler
set backspace=indent,eol,start

let vim_markdown_preview_github=1
let vim_markdown_preview_browser='Google Chrome'

let g:airline_theme='violet'

" Jump to previous position when opening a file
" https://askubuntu.com/a/202077
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
