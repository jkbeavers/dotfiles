" Make backspace behave in a sane manner.
set backspace=indent,eol,start

" Switch syntax highlighting on
syntax on

" get rid of vi compatibility
set nocompatible

colorscheme material

" I dunno what modelines are. yet... this is a security thing for now
set modelines=0

" Show status line
set laststatus=2

" allow multiple files open in different buffers
set hidden

" set to autoread when a file is changed outside
set autoread

" ignore case when searching
set ignorecase

" ignores ignorecase if there are upper case letters
set smartcase

" search like in modern browsers
set incsearch
set showmatch
set hlsearch

" be smart with yo tabs
set smarttab

" default global search replace in a line
set gdefault

" fix vim's lame ass default regex
nnoremap / /\v
vnoremap / /\v
nnoremap ? ?\v
vnoremap ? ?\v

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Show line numbers
set relativenumber
" Sets absolute number on current line (if done after set relativenumber)
set number

" Allow hidden buffers, don't limit to 1 file per window/split
set hidden

" Increase number of commands held in history
set history=100

" Faster drawing
set ttyfast

" handle long lines well
set wrap
set textwidth=79
set formatoptions=qrn1
"set colorcolumn=85

" use tab instead of %
nnoremap <tab> %
vnoremap <tab> %

" use Y to yank until end of line
noremap Y y$

" Remap jj to esc from insert mode
imap jj <Esc> 

let mapleader = ","

" clear results from search
nnoremap <leader><space> :noh<cr>

" easily view buffers
nnoremap <leader>b :buffers<cr>

" Use ack plugin to search
nnoremap <leader>a :Ack 

" quickly access vimrc in a split window
nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>

" open new vsplit and switch over to it
nnoremap <leader>v <C-w>v<C-w>l

" navigate splits using leader
nnoremap <leader>l <C-w>l
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>h <C-w>h

"
command Tex execute "w" | execute "silent !pdflatex %" | execute "redraw!"
command TexErr execute "w" | execute "!pdflatex %" 
command NotePdf execute "w" | execute "silent !pandoc --preserve-tabs --read=markdown '%:p' -o ~/Documents/notePdfs/'%:t'.pdf" | execute "redraw!" 

" Enable file type detection and do language-dependent indenting.
filetype plugin indent on

" Specify a directory for plugins 
call plug#begin('~/.vim/plugged')
" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'scrooloose/nerdcommenter'
Plug 'mileszs/ack.vim'
Plug 'xolox/vim-misc' " Dependency for notes
Plug 'xolox/vim-notes'
" Add plugins to &runtimepath
call plug#end()

:let g:notes_directories = ['~/Documents/Notes']
:let g:notes_markdown_program = 1


" Open NERDTree automatically
" autocmd vimenter * NERDTree 
" Open NERDTree if no files are specified
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Toggle NERDTree panel
map <C-n> :NERDTreeToggle<CR>
