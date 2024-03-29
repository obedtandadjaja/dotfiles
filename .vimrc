"""""""""""""""""""""""
" Vim Plug
""""""""""""""""""""""""

" Install plugged if not exists
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Initial plugged
call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'tpope/vim-abolish'
Plug 'ycm-core/YouCompleteMe' " Use if coc is unbearable
Plug 'airblade/vim-gitgutter'
Plug 'terryma/vim-multiple-cursors' " highlight word with :viw and then <C-n>
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'sonph/onehalf', { 'rtp': 'vim/' }
Plug 'itchyny/lightline.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'bitc/vim-bad-whitespace'
Plug 'liuchengxu/vim-which-key'
Plug 'majutsushi/tagbar'
Plug 'jlanzarotta/bufexplorer'

" Linter
Plug 'w0rp/ale'

" Python
Plug 'tmhedberg/SimpylFold'
Plug 'vim-python/python-syntax'
Plug 'vim-scripts/indentpython.vim'

" Dart
Plug 'dart-lang/dart-vim-plugin'
Plug 'natebosch/vim-lsc'
Plug 'natebosch/vim-lsc-dart'

" Solidity
Plug 'TovarishFin/vim-solidity'

" Syntastic
Plug 'vim-syntastic/syntastic'

" Frontend
Plug 'leafgarland/typescript-vim'
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'branch': 'release/0.x'
  \ }

call plug#end()

set nocompatible             " be iMproved, required
filetype off                 " required
set rtp+=/usr/local/opt/fzf
filetype plugin indent on    " required
colorscheme onehalfdark

""""""""""""""""""""""""
" GUI
""""""""""""""""""""""""

syntax on
set background=dark
set t_Co=256

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set number
set showcmd     " show command in bottom bar
set cursorline  " show current line
set showmatch   " highlight matching (){}{}
set lazyredraw  " redraw only when we need to
set mouse=nicr  " mouse scrolling

""""""""""""""""""""""""
" Vim Configurations
""""""""""""""""""""""""

" reload file when it changes on disk
set autoread

" Setting column to 80 characters
set colorcolumn=80
highlight ColorColumn ctermbg=red guibg=red

" Wildmenu - shows list in cmd
" Type ':color <Tab>' to try
set wildmenu
set wildmode=longest:full,full

" Set clipboard to be system wide
set clipboard=unnamed

" Disabling swap files
set noswapfile

" Vim history
set history=500

" smarter completion by infering the case
set infercase

" Search
set ignorecase  " ignore case
set incsearch   " search as characters are entered
set hlsearch    " highlight matches
set inccommand=nosplit

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
set diffopt+=vertical

" Always show status line
set laststatus=2

" Set font
set encoding=UTF-8
let g:airline_powerline_fonts = 1

" Tab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab     " tabs are spaces

" jsx should be treated like js
autocmd BufNewFile,BufRead *.jsx set filetype=javascript

" for go tab is 4
au BufNewFile,BufRead *.go setlocal noet ts=4 sw=4 sts=4 colorcolumn=100
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

" Cause files to be hidden instead of closed when opening a new file
set hidden

" Having longer updatetime (default is 4000ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Don't pass messages to |ins-completion-menu|
set shortmess+=c

" Complete option
set completeopt=longest,menuone

" set leader key to space
let mapleader="\<Space>"

" set aside space for signs next to number column
set signcolumn=yes

" Use tab for trigger completion
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Window movement
nnoremap <silent> <leader>wj <C-w>j
nnoremap <silent> <leader>wk <C-w>k
nnoremap <silent> <leader>wh <C-w>h
nnoremap <silent> <leader>wl <C-w>l

" Window splits
nnoremap <silent> <leader>w/ <C-w>v
nnoremap <silent> <leader>w- <C-w>s
nnoremap <silent> <leader>w= <C-w>=

" Buffer / Windows and files
nnoremap <silent> <leader>pf :Files<Cr>
nnoremap <silent> <leader>/ :Rg<Cr>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>w :Windows<CR>

" deleting buffer will not delete split
nmap <silent> <leader>bd :bp\|bd #<Cr>

" space tab to previous buffer
nmap <silent> <leader><TAB> :b#<Cr>

set nowrap " don't wrap lines
set ai " auto indent
set si " smart indent

" enable code folding
set foldmethod=indent
set foldlevel=99

" turn off backup
set nobackup
set nowb
set noswapfile

""""""""""""""""""""""""
" Plugin Configurations
""""""""""""""""""""""""

" ALE linter
let g:ale_fixers = {
 \ 'javascript': ['eslint'],
 \ 'typescript': ['eslint'],
 \ 'css': ['prettier'],
 \ 'sol': ['prettier'],
 \ }
let g:ale_javascript_eslint_use_global = 1

" Prettier
" when running at every change you may want to disable quickfix
let g:prettier#quickfix_enabled = 0
let g:prettier#autoformat = 0
autocmd BufWritePre *.jsx,*.js,*.json,*.css,*.scss,*.less,*.graphql,*.ts,*.tsx PrettierAsync

" YouCompleteMe
nnoremap gl :YcmCompleter GoToDeclaration<CR>
nnoremap gf :YcmCompleter GoToDefinition<CR>
nnoremap gt :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap gr :YcmCompleter GoToReferences<CR>

let g:ycm_autoclose_preview_window_after_insertion = 1

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Python
let g:python_host_prog  = "/usr/bin/python"
let g:python3_host_prog = "/usr/local/bin/python3"
let g:python_highlight_all = 1

"python with virtualenv support
py3 << EOF
import os.path
import sys
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
EOF

" [Buffers] jump to the existing window
let g:fzf_buffers_jump = 1

" ignore gitignored files
let $FZF_DEFAULT_COMMAND = 'ag -g "" --hidden'

" Ripgrep ignore filename
command! -bang -nargs=* Rg
        \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

" Make buffers start with 1-9
let i = 1
while i <= 9
    execute 'nnoremap <Leader>' . i . ' :' . i . 'wincmd w<CR>'
    let i = i + 1
endwhile

" vim-go
let g:go_fmt_command = "goimports"

" SimpylFold
let g:SimpylFold_docstring_preview=1

" WhichKey
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

" tagbar
let g:Tlist_Ctags_Cmd='/usr/local/Cellar/ctags/5.8_1/bin/ctags'
nnoremap <silent> <leader>ol :TagbarToggle<CR>

""""""""""""""""""""""""
" NERDTree
""""""""""""""""""""""""

" Open NERDTree automatically when vim starts up if no files were specified
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Open NERDTree with Ctrl+n
map <leader>pt :NERDTreeToggle<CR>
map <leader>fT :NERDTreeFind<CR>

" Close vim if the only window left open is NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.DS_Store$']
