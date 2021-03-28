set encoding=utf-8
execute pathogen#infect()

if (has("termguicolors"))
  set termguicolors
endif

if executable("lsb_release")
  let is_mac = 0
  let linux_os = substitute(system("lsb_release -si"), "\n", "", "")
  if linux_os == "ManjaroLinux"
    let linux_os = "Arch"
  endif
else
  let is_mac = 1
  let linux_os = ""
endif

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
set number
set updatetime=100
set hidden

let mapleader = ","

let g:python3_host_prog = '/usr/local/opt/python@3.9/bin/python3'

autocmd FileType markdown setlocal shiftwidth=4 ts=4
autocmd FileType go setlocal noexpandtab

" User functions
function! OneBuf()
  if len(getbufinfo({'buflisted':1})) > 1
    return 0
  endif
  return 1
endfunction

function! ToggleFileFormat()
  if &fileformat ==# "unix"
    setlocal ff=dos
  else
    setlocal ff=unix
  endif
endfunction

" ripgrep that also includes hidden files and excludes .git directories
command! -bang -nargs=* Rgh call fzf#vim#grep("rg --hidden --glob '!.git/*' --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, <bang>0)

""""""""""" User keymappings
nnoremap <silent> <Leader>ft :call ToggleFileFormat()<CR>
nnoremap <silent> <Leader>Q :q!<CR>
nnoremap <silent> <Leader>d :silent exec "!tmux detach"<CR>
" Quit if only 1 buffer, otherwise delete current buffer
nnoremap <silent> <expr> <Leader>q (OneBuf() ? ":q\<CR>" : ":bd\<CR>")
" Write shortcuts
nnoremap <silent> <Leader>w :w<CR>
nnoremap <silent> <Leader>W :w!<CR>

" vim-instant-markdown
if is_mac
  " https://stackoverflow.com/a/26962811 - nitram509
  let g:instant_markdown_browser = "'open -gna \"Google Chrome\" --args --new-window --app=\"data:text/html,<html><body><script>window.moveTo(0,0);window.resizeTo(900,900);window.location = \\\"http://localhost:8090\\\";</script></body></html>\"'"
endif

" JS/TS syntax highlighting fix
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

" vim-prettier
" autocmd TextChanged,InsertLeave *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync
" autocmd InsertLeave *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync

" coc.nvim
let g:coc_global_extensions = [
      \ 'coc-browser',
      \ 'coc-css',
      \ 'coc-emmet',
      \ 'coc-eslint',
      \ 'coc-git',
      \ 'coc-go',
      \ 'coc-highlight',
      \ 'coc-html',
      \ 'coc-html-css-support',
      \ 'coc-htmlhint',
      \ 'coc-json',
      \ 'coc-markdownlint',
      \ 'coc-pyright',
      \ 'coc-sh',
      \ 'coc-snippets',
      \ 'coc-spell-checker',
      \ 'coc-styled-components',
      \ 'coc-stylelintplus',
      \ 'coc-svg',
      \ 'coc-tabnine',
      \ 'coc-toml',
      \ 'coc-tsserver',
      \ 'coc-vimlsp',
      \ 'coc-xml',
      \ 'coc-yaml',
      \]

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

vmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>e <Plug>(coc-git-chunkinfo)
nnoremap <Leader>c :call CocAction('pickColor')<CR>
nnoremap <Leader>cp :call CocAction('colorPresentation')<CR>

" ale
let g:ale_fixers = {
\   '*': ['remove_trailing_lines','trim_whitespace'],
\   'json': ['prettier'],
\   'javascript': ['prettier','eslint','importjs'],
\   'typescriptreact': ['prettier','eslint','importjs'],
\   'css': ['prettier'],
\}
let g:ale_fix_on_save = 1
let g:ale_linters = {
    \ 'javascript': ['prettier','eslint'],
    \ 'json': ['prettier'],
    \ 'sh': ['language_server'],
    \ 'typescriptreact': ['prettier','eslint'],
    \ }
let g:ale_linters_explicit = 1
autocmd InsertLeave *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html ALEFix
nnoremap <silent> <Leader>A :ALEFix<CR>
nnoremap ]r :ALENextWrap<CR>     " move to the next ALE warning / error
nnoremap [r :ALEPreviousWrap<CR> " move to the previous ALE warning / error


""""""""""""""" NERDTree
"""" Good defaults
" Open automatically if no files opened on start
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Open auto if directory opened
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
" Auto-close vim if only NERDTree is left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"""" Key mappings
" CTRL+N will either switch focus to NERDTree or close it if it's already in focus
nnoremap <silent> <expr> <C-n> (expand('%') =~ 'NERD_tree' ? ":NERDTreeToggle\<CR>" : ":NERDTreeFocus\<CR>")
" Custom Settings
let g:NERDTreeShowHidden = 1
let g:NERDTreeMouseMode = 2
let g:NERDTreeQuitOnOpen = 3
let g:NERDTreeIgnore=['\.git$']

" The NERD Commenter
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDCommentEmptyLines = 1

" Emmet-vim
let g:user_emmet_leader_key='<C-E>'

" VimDevIcons
let g:airline_powerline_fonts = 1

" Indent Guides
let g:indent_guides_enable_on_vim_startup = 1
"let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=235
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=233

" fugitive
nnoremap <silent> <Leader>gb :Gblame<CR>
nnoremap <silent> <Leader>gd :Gdiff<CR>
nnoremap <silent> <Leader>gl :Glog<CR>
nnoremap <silent> <Leader>gs :Gstatus<CR>

" git-gutter
" disable gutter signs in favor of coc-nvim git extension
let g:gitgutter_signs = 0

"""""""""""""" fzf
"""" basic setup
if is_mac
  set rtp+=/usr/local/opt/fzf
else
  set rtp+=/usr/bin/fzf
endif
"""" Key mappings
nnoremap <silent> <expr> <Leader><Leader> (expand('%') =~ 'NERD_tree' ? "\<C-w>\<C-w>" : '').":FZF\<CR>"
nnoremap <silent> <Leader>fh :History<CR>
nnoremap <silent> <Leader>: :History:<CR>
nnoremap <silent> <Leader>/ :History/<CR>
nnoremap <silent> <Leader>fb :Buffers<CR>
nnoremap <silent> <Leader>fc :Commits<CR>
nnoremap <silent> <expr> <Leader>ff (expand('%') =~ 'NERD_tree' ? "\<C-w>\<C-w>" : '').":Rgh\<CR>"
nnoremap <silent> <expr> <Leader>fg (expand('%') =~ 'NERD_tree' ? "\<C-w>\<C-w>" : '').":GFiles\<CR>"
nnoremap <silent> <expr> <Leader>fG (expand('%') =~ 'NERD_tree' ? "\<C-w>\<C-w>" : '').":GFiles?\<CR>"

" Arpeggio
call arpeggio#map('i', '', 0, 'jk', '<Esc>')
call arpeggio#map('i', '', 0, 'wq', '<Esc>:wq<Enter>')

" Tagbar
if is_mac || linux_os == "Arch"
  nnoremap <silent> <expr> <Leader>t (expand('%') =~ 'Tagbar' ? ":TagbarToggle\<CR>" : ":TagbarOpen fj\<CR>")
  let g:tagbar_autoclose = 1
endif

"""""""""""""" vim-airline
"""""""" tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>= <Plug>AirlineSelectNextTab
"""""""" misc
let g:airline#extensions#ycm#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='kolor'
" let g:airline_theme='papercolor'

" PaperColor
let g:PaperColor_Theme_Options = {
  \   'theme': {
  \     'default.dark': {
  \       'transparent_background': 1
  \     }
  \   }
  \ }
set background=dark
colorscheme PaperColor

" Jump to previous position when opening a file
" https://askubuntu.com/a/202077
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" vim-json
let g:vim_json_syntax_conceal = 0
