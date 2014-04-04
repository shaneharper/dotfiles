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
nnoremap <leader>g* :Ggrep <C-r><C-w><CR>:copen<CR>
nnoremap <leader>* :Ggrep -P "\b<C-R><C-W>\b"<CR>:copen<CR>

" Lawrencium is 'vim-fugitive' for Mercurial
Bundle 'https://github.com/shaneharper/vim-lawrencium'
command Hdiff Hgvdiff

Bundle 'Valloric/YouCompleteMe'
    " To build YCM binary: cd ~/.vim/bundle/YouCompleteMe && ./install.sh --clang-completer

" numsign provides commands for jumping to lines marked with a 'sign' - YouCompleteMe uses 'signs' on lines causing compilation warnings/errors.
"  \sn or <F2> jumps to next line with a 'sign'.
Bundle 'https://github.com/vim-scripts/numsign.vim'
autocmd BufWinEnter,WinEnter,FocusGained * let b:sign_work_mode=0

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

Bundle 'https://github.com/embear/vim-localvimrc'
" let g:localvimrc_whitelist='/home/shane/rtags' | let g:localvimrc_sandbox=0
"  A useful .lvimrc, set makeprg to pass project root directory to ninja:
"    set makeprg=ninja\ -C\ \"\$(git\ rev-parse\ --show-toplevel)\"

" dwm.vim - Tiled Window Management for Vim
Bundle 'https://github.com/spolu/dwm.vim.git'

Bundle 'https://github.com/kien/rainbow_parentheses.vim'
"au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
"au Syntax * RainbowParenthesesLoadSquare
"au Syntax * RainbowParenthesesLoadBraces

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
"" jj: temporarily leave insert mode for one command
inoremap jj <C-o>

nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

nnoremap <space> :
vnoremap <space> :
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
    autocmd FileType c,cpp
        \ iabbrev #i #include |
        \ iabbrev #d #define|
        \ iabbrev #e #endif|
        \ iabbrev st struct|    iabbrev struct  NO! NO! NO!|
        \ iabbrev wh while|     iabbrev while   NO! NO! NO!|
        \ iabbrev re return|    iabbrev return  NO! NO! NO!|
        \ iabbrev bo bool|      iabbrev bool    NO! NO! NO!|
        \ iabbrev ch char|      iabbrev char    NO! NO! NO!|
        \ iabbrev co const|     iabbrev const   NO! NO! NO!|
        \ iabbrev vo void|      iabbrev void    NO! NO! NO!|
        \ iabbrev un unsigned|  iabbrev unsigned NO! NO! NO!|
    autocmd FileType cpp
        \ iabbrev cl class|     iabbrev class   NO! NO! NO!|
        \ iabbrev na namespace| iabbrev namespace NO! NO! NO!|
        \ iabbrev te template|  iabbrev template NO! NO! NO!|
        \ iabbrev ty typename|  iabbrev typename NO! NO! NO!|
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

autocmd FileType c,cpp nnoremap <buffer> <localleader>m :make<CR>:cwindow<CR>

autocmd BufNewFile,BufRead *.h++ set filetype=cpp

" Don't automatically insert the 'comment leader' when starting a new line next to a comment. (I tend not to use // for multi-line comments in C++.)
" set formatoptions==cro  " didn't work as expected - see http://stackoverflow.com/questions/6076592/vim-set-formatoptions-being-lost
autocmd BufNewFile,BufRead * setlocal formatoptions-=cro

set cpoptions+=n " wrapped text can appear in the line number column
highlight LineNr ctermfg=DarkGrey
set numberwidth=2
autocmd BufWinEnter,WinEnter,FocusGained * setlocal relativenumber
autocmd WinLeave,FocusLost * setlocal norelativenumber
" }}}
