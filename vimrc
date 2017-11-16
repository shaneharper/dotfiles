" vim-plug and vundle require git.


" vim-plug
if empty(glob('~/.vim/autoload/plug.vim')) && empty(glob('~/vimfiles/autoload/plug.vim'))
    if has("win32")
        echo "Install vim-plug manually"
            " From Powershell:
            " md ~\vimfiles\autoload
            " $uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
            " (New-Object Net.WebClient).DownloadFile($uri, $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath("~\vimfiles\autoload\plug.vim"))
    else
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall | source $MYVIMRC
    endif
endif

call plug#begin('~/.vim/plugged')

" Lawrencium is 'vim-fugitive' for Mercurial
Plug 'https://github.com/ludovicchabant/vim-lawrencium'
command -nargs=* Hdiff execute "Hgvdiff <args>" | call s:go_to_first_change_in_diff_mode()

" Jedi-Vim: tools for Python dev
"  <leader>n = show usages  <leader>g = go to an assignment  <leader>r = rename
Plug 'https://github.com/davidhalter/jedi-vim'

        " XXX Could Vim automatically do s:go_to_first_change_in_diff_mode() when opening a diff view?
function! s:go_to_first_change_in_diff_mode()
    silent! normal gg]c[c
    " gg]c will go to the second change if the first line was changed. (Otherwise it goes to the first change.) '[c' from the first or second change will go to the first change.
endfunction

" Ctrl-P - press Ctrl-P to open a file
Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_custom_ignore = {'file': '\v\.(o|o\.d)$'}
let g:ctrlp_match_window = 'max:20'
let g:ctrlp_extensions = ['tag', 'line']

Plug 'https://github.com/shaneharper/vim-name_object_after_its_type.git'

Plug 'https://github.com/shaneharper/vim-code_block_markers.git'

Plug 'https://github.com/alfredodeza/pytest.vim'
autocmd VimEnter,BufNewFile,BufRead,BufWrite test*.py nnoremap <buffer> <LocalLeader>t :Pytest file<CR>
autocmd VimEnter,BufNewFile,BufRead,BufWrite test*.py nnoremap <buffer> <LocalLeader>T :Pytest function<CR>

Plug 'https://github.com/powerman/vim-plugin-AnsiEsc.git'

" vital-power-assert (and dependencies).
"  Power assert allows assertions to be written using a "natural" syntax (e.g. "Assert a==b" rather than "call assert_equal('a', 'b')"). (It provides just one command/function.) It generates assertion failure messages that show the name and value of variables used in the assertion as well as values computed by functions.
Plug 'vim-jp/vital.vim'
Plug 'haya14busa/vital-vimlcompiler'
Plug 'haya14busa/vital-power-assert'
Plug 'haya14busa/vital-safe-string'

call plug#end()



" Set-up Vundle to install/update plugins --------------------------------- {{{
" :VundleUpdate updates bundles

let s:run_BundleInstall=0
if !filereadable(expand('~/.vim/bundle/vundle/README.md'))
    echo "Installing Vundle.."
    echo ""
    if has("win32")
        execute "!mkdir" $HOME."\\.vim\\bundle"
        execute "!git clone https://github.com/gmarik/vundle" $HOME."\\.vim\\bundle\\vundle"
    else
        silent !mkdir -p ~/.vim/bundle
        silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
    endif
    let s:run_BundleInstall=1
endif
set runtimepath+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

" zoomwin-vim: <C-W>o toggles fullscreen/windowed.
Bundle 'https://github.com/drn/zoomwin-vim.git'

Bundle 'https://github.com/tpope/vim-fugitive'
nnoremap <leader>g* :Ggrep <C-r><C-w><CR>:copen<CR>
nnoremap <leader>* :Ggrep -P "\b<C-R><C-W>\b"<CR>:copen<CR>
command -nargs=? Fdiff execute "Gdiff <args>" | call s:go_to_first_change_in_diff_mode() | wincmd x


Bundle 'Valloric/YouCompleteMe'
set encoding=utf-8  " YCM requires this.
    " To build YCM binary:
    "  MS Windows: set PATH=%PATH%;"c:\Program Files\CMake\bin";"c:\Program Files\7-Zip"
    "  cd ~/.vim/bundle/YouCompleteMe && ./install.py --clang-completer
autocmd InsertLeave * if bufname("%") != "[Command Line]" | pclose | endif | " (Command Line check is to silence Vim error message.)
let g:ycm_confirm_extra_conf = 0
nnoremap <leader>jd :YcmCompleter GoToDeclaration<CR>

" numsign provides commands for jumping to lines marked with a 'sign' - YouCompleteMe uses 'signs' on lines causing compilation warnings/errors.
"  \sn or <F2> jumps to next line with a 'sign'.
Bundle 'https://github.com/vim-scripts/numsign.vim'
autocmd BufWinEnter,WinEnter,FocusGained * let b:sign_work_mode=0

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
let g:localvimrc_persistent=2
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

if s:run_BundleInstall == 1
    echo "Installing Bundles, please ignore key map error messages."
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
nnoremap <silent> <BS> :nohls<CR>
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
        \ inoremap <buffer> #i0 #if 0|
        \ iabbrev <buffer> #e #endif|
        \ inoremap <buffer> #E #endif|
        \ iabbrev <buffer> st struct|    iabbrev <buffer> struct  NO! NO! NO!|
        \ iabbrev <buffer> re return|    iabbrev <buffer> return  NO! NO! NO!|
        \ iabbrev <buffer> bo bool|      iabbrev <buffer> bool    NO! NO! NO!|
        \ iabbrev <buffer> ch char|      iabbrev <buffer> char    NO! NO! NO!|
        \ iabbrev <buffer> co const|     iabbrev <buffer> const   NO! NO! NO!|
        \ iabbrev <buffer> vo void|      iabbrev <buffer> void    NO! NO! NO!|
        \ iabbrev <buffer> un unsigned|  iabbrev <buffer> unsigned NO! NO! NO!|
    " Typing "fo(" expands to "for (", "wh(" expands to "while ("
    autocmd FileType c,cpp
        \ iabbrev <buffer> eif else if |
        \ iabbrev <buffer> fo for |
        \ iabbrev <buffer> wh while |     iabbrev <buffer> while   NO! NO! NO!|
    " 'b' for brackets. Add <CR>? Another mapping with <CR>?
    autocmd FileType c,cpp inoremap <buffer> <c-b> ();
    autocmd FileType cpp
        \ iabbrev <buffer> au auto|
        \ iabbrev <buffer> ca const auto|
        \ iabbrev <buffer> cl class|     iabbrev <buffer> class   NO! NO! NO!|
        \ iabbrev <buffer> na namespace| iabbrev <buffer> namespace NO! NO! NO!|
        \ iabbrev <buffer> te template|  iabbrev <buffer> template NO! NO! NO!|
        \ iabbrev <buffer> ty typename|  iabbrev <buffer> typename NO! NO! NO!|
        \ iabbrev <buffer> pu: public:|
        \ iabbrev <buffer> pro: protected:|
        \ iabbrev <buffer> pri: private:|
    " Mappings for things in std namespace. The last two letters are the first and last letters of the abbreviated word.
    autocmd FileType cpp
        \ iabbrev <buffer> sct std::cout <<|
        \ iabbrev <buffer> scr std::cerr <<|
        \ iabbrev <buffer> sel std::endl|
        \ iabbrev <buffer> smp std::map|
        \ iabbrev <buffer> ssg std::string|
        \ iabbrev <buffer> ssk std::stack|
        \ iabbrev <buffer> sst std::set|
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
highlight Special ctermfg=magenta

" Turn off most of the default syntax highlighting. Too many colors can be distracting. Some syntax highlighting is useful though, e.g. coloring comments.
" XXX Can the syntax highlighting rules that I don't want be removed, rather than "hiding" their effect via the following?
for s:highlight_group in ['Statement', 'Number', 'Type', 'Identifier']
    execute "highlight!" s:highlight_group "NONE"
endfor

highlight diffAdded ctermfg=green guifg=green
highlight diffRemoved ctermfg=red guifg=red
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
set breakindent
set wrapscan
"set linebreak

set guioptions-=T   " hide toolbar

if has("gui_win32")
    set guifont=Courier_New:h8:cANSI
endif

if has("win32") || has("win64")
    " Fix for "E303: Unable to open swap file for "[No Name]", recovery impossible" on Windows 8.1:
    set directory=.,$TEMP
endif

augroup vimrc_miscellaneous
    autocmd!
    autocmd FileType c,cpp nnoremap <buffer> <localleader>m :make<CR>:cwindow<CR>

    autocmd BufNewFile,BufRead,BufWrite *.h++ set filetype=cpp

    " Don't automatically insert the 'comment leader' when starting a new line next to a comment. (I tend not to use // for multi-line comments in C++.)
    " set formatoptions==cro  " didn't work as expected - see http://stackoverflow.com/questions/6076592/vim-set-formatoptions-being-lost
    autocmd BufWinEnter,BufRead * setlocal formatoptions-=cro

    autocmd BufNewFile *.py 0put =\"#!/usr/bin/env python3\<nl>\"
    autocmd BufNewFile *.sh 0put =\"#!/bin/bash\<nl>\"|normal j

    autocmd FileType text set linebreak wrap
augroup END

" Don't automatically insert the 'comment leader' when starting a new line next to a comment. (I tend not to use // for multi-line comments in C++.)
" set formatoptions==cro  " didn't work as expected - see http://stackoverflow.com/questions/6076592/vim-set-formatoptions-being-lost
autocmd BufWinEnter,BufRead * setlocal formatoptions-=cro

set cpoptions+=n " wrapped text can appear in the line number column
set numberwidth=2
" XXX only set relativenumber while in normal mode?
autocmd BufWinEnter,WinEnter,FocusGained * setlocal relativenumber
autocmd WinLeave,FocusLost * setlocal norelativenumber
set lazyredraw  " If a cursor movement key is held down (why would someone do that?) having relativenumber set can make things very slow - Vim can end up with a backlog of commands. Setting lazyredraw seems to be a work around. (The problem seems to be most noticeable with "syntax on", folds and with a "tall" (~100 line) window.)

" Ctrl-L: fix last spelling mistake (http://stackoverflow.com/questions/5312235/how-to-correct-vim-spelling-mistakes-quicker)
inoremap <c-l> <c-g>u<Esc>[s1z=`]a<c-g>u
nnoremap <c-l> [s1z=<c-o>

if executable('ag')
    " Note we extract the column as well as the file and line number
    set grepprg=ag\ --nogroup\ --nocolor\ --column
    set grepformat=%f:%l:%c%m
endif

" }}}
