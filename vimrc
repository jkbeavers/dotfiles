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

" Enable file type detection and do language-dependent indenting.
filetype plugin indent on

" be smart with yo tabs
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Show line numbers
set number

" Allow hidden buffers, don't limit to 1 file per window/split
set hidden

" Increase number of commands held in history
set history=100
