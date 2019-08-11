set nocompatible              " be iMproved, required
" Disable filetype-based indentation settings
filetype indent off

" Disable loading filetype-based general configuration
filetype plugin off

" These may be combined for brevity (disabling both)
filetype plugin indent off
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'tomlion/vim-solidity'
Plugin 'scrooloose/nerdtree'
Plugin 'altercation/vim-colors-solarized'
Plugin 'https://github.com/rhysd/vim-wasm'
" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'
Plugin 'leafgarland/typescript-vim'
" git repos on your local machine (i.e. when working on your own plugin)
Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Plugin 'leafgarland/typescript-vim'
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
syntax on
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
set number
set clipboard=unnamed
let g:solarized_termcolors=256
set background=dark
colorscheme solarized
set tabstop=4
set shiftwidth=4
set autoindent
set smartindent
set expandtab
imap jj <esc>
"vmap ll <esc> 
nmap <Down> <nop>
nmap <Up> <nop>
nmap <Left> <nop>
nmap <Right> <nop>
imap <Down> <nop>
imap <Up> <nop>
imap <Left> <nop>
imap <Right> <nop>
nmap - ddp
" I should set these key mappings to use a leader key
nnoremap [c gg<c-v>GI//<esc>
nnoremap [C gg<c-v>Gld
nnoremap [s :%s/\/\/.*//g<cr> 
nnoremap [a i// @audit - 
inoremap [a // @audit - 
inoremap [p // @param - 
inoremap [r // @returns - 
inoremap [m // @modifier - 
" nnoremap _  O<esc>kd$jpj0d$kkpjjdd
let extension = expand('%:e')
if extension == "cr" 
  set filetype=ruby
endif
if extension == "c" || extension == "h"
  set tabstop=8
  set shiftwidth=8
  inoremap [u uint64_t
endif
nnoremap [js :set filetype=javascript<cr>
autocmd FileType typescript,javascript,solidity,rust autocmd BufWritePre <buffer> %s/\s\+$//e
command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> - |fmt -csw78
