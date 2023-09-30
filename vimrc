" vim-plug and vundle require git.

set runtimepath+=~/.vim  " Use ~/.vim on all platforms (~/.vim is not included in the default runtimepath for Windows). This is required on Windows for "call plug#begin(...)" below.
set runtimepath+=~/dotfiles/vim

" vim-plug plugins -------------------------------------------------------- {{{
let vim_plug_absolute_pathname=expand('~/.vim/autoload/plug.vim')
if !filereadable(vim_plug_absolute_pathname)
    execute "silent !curl -fLo" vim_plug_absolute_pathname "--create-dirs"
            \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Syntax highlighting------------------------------------------------------ {{{
Plug 'https://github.com/shaneharper/vim-mono_eink_color_scheme.git'

Plug 'pboettch/vim-cmake-syntax'  " pboettch/vim-cmake-syntax seems to fix problems with the runtime/syntax/cmake.vim that currently (on 27 Jan 2022) comes with Vim (https://github.com/vim/vim/blob/37c64c78fd87e086b5a945ad7032787c274e2dcb/runtime/syntax/cmake.vim). pboettch/vim-cmake-syntax highlights inline bracket comments ('#[[ ... ]]') correctly; Without it text beyond the end of a bracket comment would be highlighted as a comment if on the same line as the bracket comment.

Plug 'https://github.com/vim-scripts/SWIG-syntax.git'

Plug 'shaneharper/vim-dosbatch_syntax'

Plug 'https://github.com/PProvost/vim-ps1'  " Syntax highlighting, auto indenting, etc. for Powershell scripts

Plug 'https://github.com/vim-python/python-syntax'
let g:python_highlight_string_format=1  " (for syntax highlighting of f-strings, etc.)
" }}}

" Version control---------------------------------------------------------- {{{
Plug 'https://github.com/juneedahamed/vc.vim'  " works with svn, git, hg and bzr. Many commands, e.g. :VCDiff, work regardless of the type of repository. It'd be nice to use just one plugin with all version control systems but presently there are some plugins that support some version control systems better than vc.vim, e.g. vim-fugitive's :Gdiff allows individual changes to be staged to be committed to a git repository. (Another plugin that supports more version control systems is vcscommand.vim.)
command -nargs=? VCd execute "VCDiff <args>" | call s:go_to_first_change_in_diff_mode() | wincmd x

Plug 'https://github.com/ludovicchabant/vim-lawrencium'  " Use Mercurial from vim.
command -nargs=* Hdiff execute "Hgvdiff <args>" | call s:go_to_first_change_in_diff_mode()

Plug 'https://github.com/tpope/vim-fugitive'  " Use git from vim.
nnoremap <leader>g* :Ggrep <C-r><C-w><CR>:copen<CR>
nnoremap <leader>* :Ggrep -P "\b<C-R><C-W>\b"<CR>:copen<CR>
command -nargs=? Fdiff execute "Gdiff <args>" | call s:go_to_first_change_in_diff_mode() | wincmd x
" }}}

" Jedi-Vim: tools for Python dev
"  <leader>n = show usages  <leader>g = go to an assignment  <leader>r = rename
Plug 'https://github.com/davidhalter/jedi-vim'

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

Plug 'https://github.com/embear/vim-localvimrc'
let g:localvimrc_persistent=2
let g:localvimrc_whitelist=!has('win32') ? ['/home/shane/src/cpppa*', '/mnt/c/Users/shane/source/cpppa']
                                       \ : 'C:\Users\shane\source\cpppa'
let g:localvimrc_sandbox=0
"  A useful .lvimrc, set makeprg to pass project root directory to ninja:
"    set makeprg=ninja\ -C\ \"\$(git\ rev-parse\ --show-toplevel)\"

Plug 'https://github.com/editorconfig/editorconfig-vim'  " .editorconfig files allow for consistent settings in various different editors. Plugins like this one exist for other editors.
let g:EditorConfig_exclude_patterns = ['fugitive://.\*']  " (Recommended by https://github.com/editorconfig/editorconfig-vim)

Plug 'https://github.com/chrisbra/vim-diff-enhanced'  " :PatienceDiff selects the "patience" diff algorithm - this may make some diffs easier to follow.

call plug#end()
" }}}

" Vundle plugins ---------------------------------------------------------- {{{
" :PluginUpdate updates plugins

let s:run_PluginInstall=0
if !filereadable(expand('~/.vim/bundle/vundle/README.md'))
    echo "Installing Vundle."
    echo ""
    if has("win32")
        execute "!mkdir" $HOME."\\.vim\\bundle"
        execute "!git clone https://github.com/gmarik/vundle" $HOME."\\.vim\\bundle\\vundle"
    else
        silent !mkdir -p ~/.vim/bundle
        silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
    endif
    let s:run_PluginInstall=1
endif
set runtimepath+=~/.vim/bundle/vundle/
call vundle#rc()
Plugin 'gmarik/vundle'

" zoomwin-vim: <C-W>o toggles fullscreen/windowed.
Plugin 'https://github.com/drn/zoomwin-vim.git'

if !has("win32") || has("win64")  " Don't use YCM if running on Windows with 32-bit Python - see below re. problem building regex library.
    set encoding=utf-8  " As per https://github.com/ycm-core/YouCompleteMe#installation (see "Windows" section).
    Plugin 'ycm-core/YouCompleteMe'
        " To build the YCM binary on Linux:
        "  sudo apt install python3-dev mono-complete
        "  python3 ~/.vim/bundle/YouCompleteMe/install.py --clangd-completer --cs-completer
        " To build the YCM binary on Windows with Visual Studio 2022 installed:
        "  REM Note the following may not work with 32-bit Python installed. It didn't work for me with YCM d4343e8384... from 29/8/'22. Building the regex library failed, e.g. "unresolved external symbol __imp_PyTupleNew". I suspect the regex library was being built as 64-bit.
        "  python %userprofile%/.vim/bundle/YouCompleteMe/install.py --clangd-completer --cs-completer --msvc 17
        " xxx Automate building/rebuilding of the YCM binary. Use a vim-plug post-install/update hook? (Note: It seems that if the binaries need to be rebuilt that that is reported sometime after execution of this .vimrc file completes.)
    autocmd InsertLeave * if bufname("%") != "[Command Line]" | pclose | endif | " (Command Line check is to silence Vim error message.)
    let g:ycm_auto_hover=''  " Disable automatically showing documentation in a popup at the cursor location after a delay. Popups usually get in the way of reading what is near the cursor location. YCM 9309f777 unnecessarily shows a popup when the cursor is on the name of an entity where it's defined. <plug>(YCMHover) shows the popup.
    nnoremap <leader>jd :YcmCompleter GoToDeclaration<CR>
    nnoremap <leader>dt :YcmCompleter GetType<CR>
endif

" numsign provides commands for jumping to lines marked with a 'sign' - YouCompleteMe uses 'signs' on lines causing compilation warnings/errors.
"  \sn or <F2> jumps to next line with a 'sign'.
Plugin 'https://github.com/vim-scripts/numsign.vim'
autocmd BufWinEnter,WinEnter * let b:sign_work_mode=0

" Unimpaired: ]q is :cnext, [q is :cprevious, ]l is :lnext, ]l is :lprevious, etc.
Plugin 'https://github.com/tpope/vim-repeat'
Plugin 'https://github.com/tpope/vim-unimpaired'

" vim-togglelist: <leader>q toggles quickfix window, <leader>l toggles location list
Plugin 'https://github.com/milkypostman/vim-togglelist'

"    Plugin 'Syntastic'	" awesome syntax and errors highlighter

Plugin 'https://github.com/Vimjas/vim-python-pep8-indent.git'

Plugin 'https://github.com/t9md/vim-choosewin'
nmap - <Plug>(choosewin)

" dwm.vim - Tiled Window Management for Vim
" XXX disabled 'cause it moves location list windows around.  Plugin 'https://github.com/spolu/dwm.vim.git'

Plugin 'https://github.com/kien/rainbow_parentheses.vim'
"au VimEnter * RainbowParenthesesToggle " XXX Uncommenting this messes up highlighting of multi-line C++11 raw strings
au Syntax * RainbowParenthesesLoadRound
"au Syntax * RainbowParenthesesLoadSquare
"au Syntax * RainbowParenthesesLoadBraces

" Argtextobj.vim: daa = delete argument in C function signature, cia = change "inner" argument (exclude comma), ...
Plugin 'https://github.com/vim-scripts/argtextobj.vim'

Plugin 'https://github.com/tpope/vim-commentary.git'
autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s

if s:run_PluginInstall == 1
    echo "Installing Vundle plugins, please ignore key map error messages."
    echo ""
    :PluginInstall
endif
" }}}

" Basic key mappings ------------------------------------------------------ {{{
" jk mapping from http://learnvimscriptthehardway.stevelosh.com/chapters/10.html
inoremap jk <esc>
"" kk: temporarily leave insert mode for one command
inoremap kk <C-o>

nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

nnoremap <space> :
vnoremap <space> :

" From https://github.com/nvie/vimrc/blob/master/vimrc:
noremap <C-e> 2<C-e>
noremap <C-y> 2<C-y>

" dO/dP: copy changes between diffs and jump to next change. (Uses vim-unimpaired.)
nmap dO do]c
nmap dP dp]c

" Y: copy till end of line, which is consistent with D which deletes till the end of line. (By default Y copies a whole line.)
map Y y$
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

augroup c_cpp_cs_filetype_abbreviations
    autocmd!
    autocmd FileType c,cpp,swig
        \ iabbrev <buffer> #i #include |
        \ iabbrev <buffer> #d #define|
        \ inoremap <buffer> #i0 #if 0|
        \ iabbrev <buffer> st struct|    iabbrev <buffer> struct  NO! NO! NO!|
        \ iabbrev <buffer> bo bool|      iabbrev <buffer> bool    NO! NO! NO!|
        \ iabbrev <buffer> ch char|      iabbrev <buffer> char    NO! NO! NO!|
        \ iabbrev <buffer> co const|     iabbrev <buffer> const   NO! NO! NO!|
        \ iabbrev <buffer> un unsigned|  iabbrev <buffer> unsigned NO! NO! NO!|
    autocmd FileType c,cpp,cs,swig
        \ inoremap <buffer> #iF #if false|
        \ inoremap <buffer> #E #endif|
        \ iabbrev <buffer> re return|
        \ iabbrev <buffer> vo void
    autocmd FileType cpp,cs,swig
        \ iabbrev <buffer> cl class|     iabbrev <buffer> class   NO! NO! NO!|
    " Typing "fo(" expands to "for (", "wh(" expands to "while ("
    autocmd FileType c,cpp,swig
        \ iabbrev <buffer> eif else if |
        \ iabbrev <buffer> fo for |
        \ iabbrev <buffer> wh while |     iabbrev <buffer> while   NO! NO! NO!|
    " 'b' for brackets. Add <CR>? Another mapping with <CR>?
    autocmd FileType c,cpp inoremap <buffer> <c-b> ();
    autocmd FileType cpp,swig
        \ iabbrev <buffer> au auto|
        \ iabbrev <buffer> ca const auto|
        \ iabbrev <buffer> na namespace| iabbrev <buffer> namespace NO! NO! NO!|
        \ iabbrev <buffer> te template|  iabbrev <buffer> template NO! NO! NO!|
        \ iabbrev <buffer> ty typename|  iabbrev <buffer> typename NO! NO! NO!|
        \ iabbrev <buffer> pu: public:|
        \ iabbrev <buffer> pro: protected:|
        \ iabbrev <buffer> pri: private:|
    " Mappings for things in std namespace. The last two letters are the first and last letters of the abbreviated word.
    autocmd FileType cpp,swig
        \ iabbrev <buffer> sct std::cout <<|
        \ iabbrev <buffer> scr std::cerr <<|
        \ iabbrev <buffer> sel std::endl|
        \ iabbrev <buffer> smp std::map|
        \ iabbrev <buffer> ssg std::string|
        \ iabbrev <buffer> ssv std::string_view|
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

function Setup_command_alias(from, to)
    exec 'cnoreabbrev <expr>' a:from
            \ '((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
            \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfunction
" }}}

" Misc. ------------------------------------------------------------------- {{{
let &background=($VIM_BACKGROUND != "" ? $VIM_BACKGROUND : 'dark')  " XXX I wish Vim would automatically set the background option based on the color of the background of the terminal. With Vim 8.1-561 and gnome-terminal on Ubuntu 18.04 I've only seen :set background& set the background option to 'light' (even when the terminal window background color was black and v:termrbgresp was ^[]11;rgb:0000/0000/0000^G ...I'd be nice to patch Vim to fix this).  https://github.com/vim/vim/issues/869  (Set default background color (:set bg&) after detecting terminal background color)  XXX I can't set Vim's background option myself here based on v:termrbgresp because Vim doesn't set v:termrbgresp until some time after Vim has finished sourcing .vimrc. It is set sometime after when a VimEnter autocmd would fire. (Could Vim set v:termrbgresp earlier?)
syntax on
colorscheme mono_eink

filetype plugin indent on
set ruler
set tags=./tags;                " ';' causes search to occur in current directory, then the parent, then its parent, etc.
if !has('gui_running') | set mouse= | endif  " Disable Vim's mouse handling when not running gvim; Note by default Vim sets the mouse option for the Win32 terminal (see "default" at top of :help mouse). I like for the terminal window to be left to provide copy and paste functionality using the OS/window manager clipboard. (With mouse=a as set by Vim by default when the GUI is started a selection made while holding down the left mouse button will cause Vim to enter 'visual mode'.)
set mousemodel=popup_setpos
set wildmode=list:longest
set gdefault                    " search/replace "globally" (on a line) by default
set wildignore=*.swp,*.bak,*.pyc,*.class

set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set scrolloff=4                 " minimal number of screen lines to keep above and below the cursor.
set nowrap
set breakindent
set wrapscan  " searches wrap around the end of file.
"set linebreak

set nofixendofline  " Stop Vim automatically appending unwanted \r\n characters to the last line of "Windows text files". (I got tired of seeing an unintended change in a diff with the original version of a file.)
" Disabling the fixendofline option improves Vim's handling of "Windows text files" but there are still some minor issues, viz. 1/. Vim will not display the last line if it's an empty line, 2/. a new file with fileformat=dos will be saved with a blank line added to the end (unless the endofline option was cleared). These issues could be solved if Vim's interpretation of \n characters could be configured; With fileformat set to "unix" \n could be interpreted as a line terminator (required at the end of all lines, including the last) and with fileformat set to "dos" \n could be interpreted as a line separator (so a \n at the end of a file indicates that an empty line follows the \n - the \n separates the empty line at the very end from the second from last line). The fixendofline option wouldn't be required if Vim's interpretation of \n characters could be configured as just described - the endofline option could still exist to handle the rare case of someone wanting to create a "Unix text file" without a final newline character (although I'd prefer if it was called "lastlineendswithEOL").

set guioptions-=T   " hide toolbar
set guioptions+=k   " keep window size when adding/removing a scrollbar, toolbar, etc.

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
    autocmd BufNewFile *.h++ 0put =\"#pragma once\"|normal G
    autocmd BufNewFile *.py 0put =\"#!/usr/bin/env python3\"|normal G
    autocmd BufNewFile,BufRead,BufWrite *.vim+ if !exists('b:current_syntax') | setfiletype vim | endif   " See: https://github.com/shaneharper/add_vim_script_end_statements
    autocmd BufNewFile,BufRead,BufWrite *.xaml setfiletype xml
    autocmd FileType text,markdown,hgcommit,gitcommit set linebreak wrap
    autocmd FileType diff,git set wrap
    autocmd BufNewFile,BufRead,BufWrite *.swg setfiletype swig
    autocmd BufWinEnter * call <SID>set_formatoptions_for_buffer()  " This autocmd is executed after ftplugin scripts have run. (This way we can override unwanted formatoptions settings that may have been made by an ftplugin script.)
    autocmd BufNewFile,BufRead,BufWrite .clang-tidy set filetype=yaml
    autocmd BufNewFile *.bat,*.cmd set fileformat=dos
augroup END

function s:set_formatoptions_for_buffer()
    setlocal formatoptions-=c formatoptions-=t   | " No automatic insertion of new-line characters to avoid "long" lines. (Long lines can be formatted when a file is viewed, e.g. by setting Vim's linebreak and wrap options.)
    setlocal formatoptions-=r formatoptions-=o   | " No automatic insertion of the "comment leader" when starting a new line following a comment line.

    " Notes:
    " 1/. Trying to remove several flags at once (e.g. setlocal formatoptions-=cro) will only change formatoptions if all of the specified flags were set. (See :help :set-=)
    " 2/. &textwidth will be ignored after clearing the flags above, except when formatting with 'gq'.
endfunction

set cpoptions+=n " wrapped text can appear in the line number column
set numberwidth=2
" XXX only set relativenumber while in normal mode?
autocmd BufWinEnter,WinEnter * setlocal relativenumber
autocmd WinLeave * setlocal norelativenumber
set lazyredraw

" Ctrl-L: fix last spelling mistake (http://stackoverflow.com/questions/5312235/how-to-correct-vim-spelling-mistakes-quicker)
inoremap <c-l> <c-g>u<Esc>[s1z=`]a<c-g>u
nnoremap <c-l> [s1z=<c-o>

if executable('ag')
    " Note we extract the column as well as the file and line number
    set grepprg=ag\ --nogroup\ --nocolor\ --column
    set grepformat=%f:%l:%c%m
endif

function s:go_to_first_change_in_diff_mode()  " XXX Could Vim automatically do s:go_to_first_change_in_diff_mode() when opening a diff view?
    silent! normal gg]c[c
    " gg]c will go to the second change if the first line was changed. (Otherwise it goes to the first change.) '[c' from the first or second change will go to the first change.
endfunction
" }}}

" vim:set foldmethod=marker:
