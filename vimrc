" Make backspace behave in a sane manner.
set backspace=indent,eol,start

" Switch syntax highlighting on
syntax on

colorscheme material

" set to autoread when a file is changed outside
set autoread

" ignore case when searching
set ignorecase

" search like in modern browsers
set incsearch


" be smart with yo tabs
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Show line numbers
set relativenumber

" Allow hidden buffers, don't limit to 1 file per window/split
set hidden

" Increase number of commands held in history
set history=100

"
command Tex execute "w" | execute "silent !pdflatex %" | execute "redraw!"

" Enable file type detection and do language-dependent indenting.
filetype plugin indent on

" Specify a directory for plugins 
call plug#begin('~/.vim/plugged')
" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" Add plugins to &runtimepath
call plug#end()

" Open NERDTree automatically
" autocmd vimenter * NERDTree 
" Open NERDTree if no files are specified
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Toggle NERDTree panel
map <C-n> :NERDTreeToggle<CR>

