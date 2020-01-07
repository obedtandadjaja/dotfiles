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
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'airblade/vim-gitgutter'
Plug 'terryma/vim-multiple-cursors'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'cespare/vim-toml'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'

call plug#end()

set nocompatible             " be iMproved, required
filetype off                 " required
set rtp+=/usr/local/opt/fzf
filetype plugin indent on    " required

""""""""""""""""""""""""
" GUI
""""""""""""""""""""""""

syntax enable
set t_Co=256
colorscheme gruvbox

set number
set showcmd     " show command in bottom bar
set cursorline  " show current line
set showmatch   " highlight matching (){}{}
set lazyredraw  " redraw only when we need to

""""""""""""""""""""""""
" Vim Configurations
""""""""""""""""""""""""

" Set clipboard to be system wide
set clipboard=unnamed

" Disabling swap files
set noswapfile

" Ignore case when searching
set ignorecase
set incsearch   " search as characters are entered
set hlsearch    " highlight matches

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
set diffopt+=vertical

" copy selection to clipboard - Ctrl + c
vmap <C-c> :w !pbcopy<CR><CR>

" Tab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab "tag are spaces"

" for go tab is 4
autocmd Filetype go setlocal ts=4 sw=4 sts=0 expandtab

" Cause files to be hidden instead of closed when opening a new file
set hidden

" set leader key to space
let mapleader="\<Space>"

set updatetime=300

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

" deleting buffer will not delete split
nmap <silent> <leader>bd :bp\|bd #<Cr>

" space tab to previous buffer
nmap <silent> <leader><TAB> :b#<Cr>

""""""""""""""""""""""""
" Plugin Configurations
""""""""""""""""""""""""

let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-json',
  \ 'coc-go',
  \ ]

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> g[ <Plug>(coc-diagnostic-prev)
nmap <silent> g] <Plug>(coc-diagnostic-next)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" use `:Organize` for organize import of current buffer
command! -nargs=0 Organize :call CocAction('runCommand', 'editor.action.organizeImport')

" Python
let g:python_host_prog  = "/usr/bin/python"
let g:python3_host_prog = "/usr/local/bin/python3"

" [Buffers] jump to the existing window
let g:fzf_buffers_jump = 1

" Ripgrep ignore filename
command! -bang -nargs=* Rg
  \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

nnoremap <silent> <leader>pf :Files<Cr>
nnoremap <silent> <leader>/ :Rg<Cr>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>w :Windows<CR>

let i = 1
while i <= 9
    execute 'nnoremap <Leader>' . i . ' :' . i . 'wincmd w<CR>'
    let i = i + 1
endwhile

" vim-go
let g:go_fmt_command = "goimports"

" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#enabled = 1

""""""""""""""""""""""""
" NERDTree
""""""""""""""""""""""""

" Open NERDTree automatically when vim starts up if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Open NERDTree with Ctrl+n
map <leader>pt :NERDTreeToggle<CR>
map <leader>fT :NERDTreeFind<CR>

" Close vim if the only window left open is NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.DS_Store$']
