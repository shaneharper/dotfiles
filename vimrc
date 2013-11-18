" Set-up Vundle - the vim plugin bundler ---------------------------------- {{{
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
    
"    Bundle 'Syntastic'	" awesome syntax and errors highlighter
    Bundle 'https://github.com/tpope/vim-fugitive'
    Bundle 'Valloric/YouCompleteMe'
"    Bundle 'Lokaltog/vim-easymotion'

    if RunBundleInstall == 1
        echo "Installing Bundles, please ignore key map error messages"
        echo ""
        :BundleInstall
    endif
" }}}

" Basic key mappings ------------------------------------------------------ {{{
" jk mapping from http://learnvimscriptthehardway.stevelosh.com/chapters/10.html
inoremap jk <esc>
inoremap <esc> <nop>  " Use jk - it's easier, fingers stay on the home row.

nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

nnoremap <space> :
" XXX remap Caps Lock?

" From https://github.com/nvie/vimrc/blob/master/vimrc:
noremap <C-e> 2<C-e>
noremap <C-y> 2<C-y>

map <C-n> :cn<CR>
map <C-p> :cp<CR>
" }}}

" Search options ---------------------------------------------------------- {{{
set hlsearch
set incsearch
"set ignorecase                  " ignore case when searching
"set smartcase                   " ignore case if search pattern is all lowercase,
"                                "    case-sensitive otherwise
" }}}

" Indent ------------------------------------------------------------------ {{{
set expandtab
set softtabstop=4               " when hitting <BS>, pretend like a tab is removed, even if spaces
set shiftwidth=4
set autoindent                  " always set autoindenting on
set shiftround                  " round indent to multiple of shiftwidth - applies to < and > commands.
" }}}

" Abbreviations ----------------------------------------------------------- {{{
iabbrev ME shane@shaneharper.net

augroup filetype_c
    autocmd!
    autocmd FileType cpp iabbrev #i #include
    autocmd FileType cpp iabbrev #d #define
    autocmd FileType cpp
        \ iabbrev C  class|     iabbrev class   NO! NO! NO!|
        \ iabbrev S  struct|    iabbrev struct  NO! NO! NO!|
        \ iabbrev R  return|    iabbrev return  NO! NO! NO!|
        \ iabbrev W  while|     iabbrev while   NO! NO! NO!|
        \ iabbrev F  for|
        \ iabbrev T  typedef|   iabbrev typedef NO! NO! NO!|
        \ iabbrev bb bool|      iabbrev bool    NO! NO! NO!|
        \ iabbrev cc char|      iabbrev char    NO! NO! NO!|
        \ iabbrev vv void|      iabbrev void    NO! NO! NO!|
        \ iabbrev uu unsigned|  iabbrev unsigned NO! NO! NO!|
    autocmd FileType cpp iabbrev fi for (int i = 0; i < ; ++i)
augroup END
" }}}

" Misc. ------------------------------------------------------------------- {{{
set ruler
"set mouse=a                     " mouse click in an xterm moves cursor
set wildmode=list:longest
set gdefault                    " search/replace "globally" (on a line) by default
set wildignore=*.swp,*.bak,*.pyc,*.class

set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set scrolloff=4                 " minimal number of screen lines to keep above and below the cursor.
syntax on
" }}}
