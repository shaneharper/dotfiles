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
Bundle 'https://github.com/ludovicchabant/vim-lawrencium'
command Hdiff Hgvdiff

Bundle 'Valloric/YouCompleteMe'
    " To build YCM binary: cd ~/.vim/bundle/YouCompleteMe && ./install.sh --clang-completer
autocmd InsertLeave * if bufname("%") != "[Command Line]" | pclose | endif | " (Command Line check is to silence Vim error message.)

" numsign provides commands for jumping to lines marked with a 'sign' - YouCompleteMe uses 'signs' on lines causing compilation warnings/errors.
"  \sn or <F2> jumps to next line with a 'sign'.
Bundle 'https://github.com/vim-scripts/numsign.vim'
autocmd BufWinEnter,WinEnter,FocusGained * let b:sign_work_mode=0

" Ctrl-P - press Ctrl-P to open a file
Bundle 'kien/ctrlp.vim'

" Unimpaired: ]q is :cnext, [q is :cprevious, ]l is :lnext, ]l is :lprevious, etc.
Bundle 'https://github.com/tpope/vim-repeat'
Bundle 'https://github.com/tpope/vim-unimpaired'

" vim-togglelist: <leader>q toggles quickfix window, <leader>l toggles location list
Bundle 'https://github.com/milkypostman/vim-togglelist'

"    Bundle 'Syntastic'	" awesome syntax and errors highlighter

Bundle 'https://github.com/hynek/vim-python-pep8-indent.git'

Bundle 'https://github.com/t9md/vim-choosewin'
nmap - <Plug>(choosewin)

Bundle 'https://github.com/embear/vim-localvimrc'
" let g:localvimrc_whitelist='/home/shane/src/llvm' | let g:localvimrc_sandbox=0
"  A useful .lvimrc, set makeprg to pass project root directory to ninja:
"    set makeprg=ninja\ -C\ \"\$(git\ rev-parse\ --show-toplevel)\"

" dwm.vim - Tiled Window Management for Vim
" XXX disabled 'cause it moves location list windows around.  Bundle 'https://github.com/spolu/dwm.vim.git'

Bundle 'https://github.com/kien/rainbow_parentheses.vim'
"au VimEnter * RainbowParenthesesToggle " XXX Uncommenting this messes up highlighting of multi-line C++11 raw strings
au Syntax * RainbowParenthesesLoadRound
"au Syntax * RainbowParenthesesLoadSquare
"au Syntax * RainbowParenthesesLoadBraces

" Argtextobj.vim: daa = delete argument in C function signature, cia = change "inner" argument (exclude comma), ...
Bundle 'https://github.com/vim-scripts/argtextobj.vim'

Bundle 'https://github.com/tpope/vim-commentary.git'
autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s

Bundle 'https://github.com/shaneharper/vim-name_object_after_its_type.git'

Bundle 'https://github.com/shaneharper/vim-code_block_markers.git'

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
"" kk: temporarily leave insert mode for one command
inoremap kk <C-o>

nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

nnoremap <space> :
nnoremap q<space> q:
vnoremap <space> :
" XXX remap Caps Lock?

" From https://github.com/nvie/vimrc/blob/master/vimrc:
noremap <C-e> 2<C-e>
noremap <C-y> 2<C-y>

" dO/dP: copy changes between diffs and jump to next change. (Uses vim-unimpaired.)
nmap dO do]c
nmap dP dp]c
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

augroup c_filetype_abbreviations
    autocmd!
    autocmd FileType c,cpp
        \ iabbrev <buffer> #i #include |
        \ iabbrev <buffer> #d #define|
        \ iabbrev <buffer> #e #endif|
        \ iabbrev <buffer> st struct|    iabbrev <buffer> struct  NO! NO! NO!|
        \ iabbrev <buffer> wh while|     iabbrev <buffer> while   NO! NO! NO!|
        \ iabbrev <buffer> re return|    iabbrev <buffer> return  NO! NO! NO!|
        \ iabbrev <buffer> bo bool|      iabbrev <buffer> bool    NO! NO! NO!|
        \ iabbrev <buffer> ch char|      iabbrev <buffer> char    NO! NO! NO!|
        \ iabbrev <buffer> co const|     iabbrev <buffer> const   NO! NO! NO!|
        \ iabbrev <buffer> vo void|      iabbrev <buffer> void    NO! NO! NO!|
        \ iabbrev <buffer> un unsigned|  iabbrev <buffer> unsigned NO! NO! NO!|
    autocmd FileType cpp
        \ iabbrev <buffer> au auto|
        \ iabbrev <buffer> cl class|     iabbrev <buffer> class   NO! NO! NO!|
        \ iabbrev <buffer> na namespace| iabbrev <buffer> namespace NO! NO! NO!|
        \ iabbrev <buffer> te template|  iabbrev <buffer> template NO! NO! NO!|
        \ iabbrev <buffer> ty typename|  iabbrev <buffer> typename NO! NO! NO!|
    " Mappings for things in std namespace. The last two letters are the first and last letters of the abbreviated word.
    autocmd FileType cpp
        \ iabbrev <buffer> sct std::cout <<|
        \ iabbrev <buffer> scr std::cerr <<|
        \ iabbrev <buffer> sel std::endl|
        \ iabbrev <buffer> smp std::map|
        \ iabbrev <buffer> ssg std::string|
        \ iabbrev <buffer> svr std::vector|
augroup END

augroup vim_filetype_abbreviations
    autocmd!
    autocmd FileType vim
        \ iabbrev <buffer> fu function|
        \ iabbrev <buffer> re return|
        \ iabbrev <buffer> wh while|
augroup END

function! SetupCommandAlias(from, to)
    exec 'cnoreabbrev <expr> '.a:from
            \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
            \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfunction
" }}}

" Colors ------------------------------------------------------------------ {{{
set background=light
if $COLORTERM == "gnome-terminal"
    set t_Co=256
    " (Running "export TERM=gnome-256color" from .bashrc can also be used to get 256 color support.)
endif
syntax on
highlight CursorLine cterm=NONE ctermbg=darkblue ctermfg=white guibg=darkblue guifg=white  " One reason for doing this was the default cursorline (an underline) didn't appear on the last line of a buffer on Mac OS X 10.10 (vim 7.4), while this works.
highlight LineNr ctermfg=DarkGrey

" Turn off most of the default syntax highlighting. Too many colors can be distracting. Some syntax highlighting is useful though, e.g. coloring comments.
" XXX Can the syntax highlighting rules that I don't want be removed, rather than "hiding" their effect via the following highlight statements?
highlight Statement ctermfg=black
highlight Number ctermfg=black
highlight Type ctermfg=black
highlight Identifier ctermfg=black
" }}}

" Misc. ------------------------------------------------------------------- {{{
filetype plugin indent on
set ruler
set tags=./tags;                " ';' causes search to occur in current directory, then the parent, then its parent, etc.
"set mouse=a                     " mouse click in an xterm moves cursor
set wildmode=list:longest
set gdefault                    " search/replace "globally" (on a line) by default
set wildignore=*.swp,*.bak,*.pyc,*.class

set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set scrolloff=4                 " minimal number of screen lines to keep above and below the cursor.
set nowrap
if has("gui_win32")
    set guifont=Courier_New:h8:cANSI
endif

if has("win32") || has("win64")
    " Fix for "E303: Unable to open swap file for "[No Name]", recovery impossible" on Windows 8.1:
    set directory=.,$TEMP
endif

autocmd FileType c,cpp nnoremap <buffer> <localleader>m :make<CR>:cwindow<CR>

autocmd BufNewFile,BufRead,BufWrite *.h++ set filetype=cpp

" Don't automatically insert the 'comment leader' when starting a new line next to a comment. (I tend not to use // for multi-line comments in C++.)
" set formatoptions==cro  " didn't work as expected - see http://stackoverflow.com/questions/6076592/vim-set-formatoptions-being-lost
autocmd BufNewFile,BufRead * setlocal formatoptions-=cro

set cpoptions+=n " wrapped text can appear in the line number column
set numberwidth=2
autocmd BufWinEnter,WinEnter,FocusGained * setlocal relativenumber
autocmd WinLeave,FocusLost * setlocal norelativenumber
" }}}
