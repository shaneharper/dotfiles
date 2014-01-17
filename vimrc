" Set-up Vundle to install/update plugins --------------------------------- {{{
" :BundleUpdate updates bundles

let RunBundleInstall=0
if !filereadable(expand('~/.vim/bundle/vundle/README.md'))
    echo "Installing Vundle.."
    echo ""
    silent !mkdir -p ~/.vim/bundle
    silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
    let RunBundleInstall=1
endif
set runtimepath+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

Bundle 'https://github.com/tpope/vim-fugitive'
Bundle 'Valloric/YouCompleteMe'
    " To build YCM binary: cd ~/.vim/bundle/YouCompleteMe && ./install.sh --clang-completer

" Ctrl-P - press Ctrl-P to open a file
Bundle 'kien/ctrlp.vim'

" Unimpaired: ]q is :cnext, [q is :cprevious, etc.
Bundle 'https://github.com/tpope/vim-repeat'
Bundle 'https://github.com/tpope/vim-unimpaired'

" vim-togglelist: <leader>q toggles quickfix window, <leader>l toggles location list
Bundle 'https://github.com/milkypostman/vim-togglelist'

" Snipmate (and dependencies)
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'garbas/vim-snipmate'
" XXX http://stackoverflow.com/questions/14896327/ultisnips-and-youcompleteme

"    Bundle 'Lokaltog/vim-easymotion'
"    Bundle 'Syntastic'	" awesome syntax and errors highlighter

Bundle 'https://github.com/hynek/vim-python-pep8-indent.git'

Bundle 'https://github.com/shaneharper/vim-rtags.git'

if RunBundleInstall == 1
    echo "Installing Bundles, please ignore key map error messages"
    echo ""
    :BundleInstall
endif
" }}}

" Basic key mappings ------------------------------------------------------ {{{
" jk mapping from http://learnvimscriptthehardway.stevelosh.com/chapters/10.html
inoremap jk <esc>
" don't use <esc>. Use jk - it's easier, fingers stay on the home row.
inoremap <esc> <nop>

nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

nnoremap <space> :
" XXX remap Caps Lock?

" From https://github.com/nvie/vimrc/blob/master/vimrc:
noremap <C-e> 2<C-e>
noremap <C-y> 2<C-y>
" }}}

" Search options ---------------------------------------------------------- {{{
set hlsearch
set incsearch
nnoremap <leader>h :nohls<CR>
"set ignorecase                  " ignore case when searching
"set smartcase                   " ignore case if search pattern is all lowercase,
"                                "    case-sensitive otherwise
" }}}

" Indent ------------------------------------------------------------------ {{{
set expandtab
set softtabstop=4               " when hitting <BS>, pretend like a tab is removed, even if spaces
set shiftwidth=4
set autoindent
set shiftround                  " round indent to multiple of shiftwidth - applies to < and > commands.
" }}}

" Abbreviations ----------------------------------------------------------- {{{
iabbrev ME shane@shaneharper.net

augroup filetype_c
    autocmd!
    autocmd FileType cpp iabbrev #i #include
    autocmd FileType cpp iabbrev #d #define
    autocmd FileType cpp
        \ iabbrev na namespace| iabbrev namespace NO! NO! NO!|
        \ iabbrev st struct|    iabbrev struct  NO! NO! NO!|
        \ iabbrev cl class|     iabbrev class   NO! NO! NO!|
        \ iabbrev wh while|     iabbrev while   NO! NO! NO!|
        \ iabbrev re return|    iabbrev return  NO! NO! NO!|
        \ iabbrev ty typedef|   iabbrev typedef NO! NO! NO!|
        \ iabbrev bo bool|      iabbrev bool    NO! NO! NO!|
        \ iabbrev ch char|      iabbrev char    NO! NO! NO!|
        \ iabbrev vo void|      iabbrev void    NO! NO! NO!|
        \ iabbrev un unsigned|  iabbrev unsigned NO! NO! NO!|
        \ iabbrev te template|  iabbrev template NO! NO! NO!|
    set cindent
augroup END
" }}}

" Misc. ------------------------------------------------------------------- {{{
filetype plugin indent on
set ruler
"set mouse=a                     " mouse click in an xterm moves cursor
set wildmode=list:longest
set gdefault                    " search/replace "globally" (on a line) by default
set wildignore=*.swp,*.bak,*.pyc,*.class

set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set scrolloff=4                 " minimal number of screen lines to keep above and below the cursor.
set background=dark
syntax on

let g:ycm_key_list_select_completion = ['<Down>']  " was: ['<TAB>', '<Down>']. TAB is used by SnipMate, though.
" }}}
