" vim-plug and vundle require git.

set runtimepath+=~/.vim  " Use ~/.vim on all platforms (~/.vim is not included in the default runtimepath for Windows). This is required on Windows for "call plug#begin(...)" below.
set runtimepath+=~/dotfiles/vim

" vim-plug plugins -------------------------------------------------------- {{{
let s:run_PlugInstall = 0
let vim_plug_absolute_pathname=expand('~/.vim/autoload/plug.vim')
if !filereadable(vim_plug_absolute_pathname)
    execute "silent !curl -fLo" vim_plug_absolute_pathname "--create-dirs"
            \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    let s:run_PlugInstall = 1
endif

call plug#begin('~/.vim/plugged')
let g:plug_url_format='git@github.com:%s.git'

" Syntax highlighting------------------------------------------------------ {{{
Plug 'shaneharper/vim-mono_eink_color_scheme'

Plug 'pboettch/vim-cmake-syntax'  " pboettch/vim-cmake-syntax seems to fix problems with the runtime/syntax/cmake.vim that currently (on 27 Jan 2022) comes with Vim (https://github.com/vim/vim/blob/37c64c78fd87e086b5a945ad7032787c274e2dcb/runtime/syntax/cmake.vim). pboettch/vim-cmake-syntax highlights inline bracket comments ('#[[ ... ]]') correctly; Without it text beyond the end of a bracket comment would be highlighted as a comment if on the same line as the bracket comment.

Plug 'vim-scripts/SWIG-syntax'

Plug 'shaneharper/vim-dosbatch_syntax'

Plug 'PProvost/vim-ps1'  " Syntax highlighting, auto indenting, etc. for Powershell scripts

Plug 'vim-python/python-syntax'
let g:python_highlight_string_format=1  " (for syntax highlighting of f-strings, etc.)
" }}}

" Version control---------------------------------------------------------- {{{
Plug 'juneedahamed/vc.vim'  " works with svn, git, hg and bzr. Many commands, e.g. :VCDiff, work regardless of the type of repository. It'd be nice to use just one plugin with all version control systems but presently there are some plugins that support some version control systems better than vc.vim, e.g. vim-fugitive's :Gdiff allows individual changes to be staged to be committed to a git repository. (Another plugin that supports more version control systems is vcscommand.vim.)
command -nargs=? VCd execute "VCDiff <args>" | call s:go_to_first_change_in_diff_mode() | wincmd x

Plug 'ludovicchabant/vim-lawrencium'  " Use Mercurial from vim.
command -nargs=* Hdiff execute "Hgvdiff <args>" | call s:go_to_first_change_in_diff_mode()

Plug 'tpope/vim-fugitive'  " Use git from vim.
nnoremap <leader>g* :Ggrep <C-r><C-w><CR>:copen<CR>
nnoremap <leader>* :Ggrep -P "\b<C-R><C-W>\b"<CR>:copen<CR>
command -nargs=? Fdiff execute "Gdiff <args>" | call s:go_to_first_change_in_diff_mode() | wincmd x
" }}}

Plug 'ypcrts/securemodelines'
autocmd FileType diff,git let b:disable_secure_modelines=1  " Prevent processing of modelines in a diff. {{{
" We want to ensure that none of the diff is initially hidden by a fold. And by preventing processing of modelines in a diff there'll be consistency in how diffs are displayed, etc.
" Notes:
"   - Text could be "hidden" if foldmethod were to be set to something other than manual.
"   - Regarding "consistency":
"       - Diffs for a file with a modeline will not always contain the modeline - it depends on what was changed.
"       - A modeline might not apply to all files in a diff. (And a modeline in the diff might now be removed.)
" xxx The securemodelines plugin could ignore modelines appearing in a diff (then there'd be no need for this autocmd).
"    Replace: au BufRead,StdinReadPost * :call <SID>DoModelines()
"    with:    au BufRead,StdinReadPost * if &filetype !=# 'diff' && &filetype !=# 'git' | call <SID>DoModelines() | endif
" }}}


" Jedi-Vim: tools for Python dev
"  <leader>n = show usages  <leader>g = go to an assignment  <leader>r = rename
Plug 'davidhalter/jedi-vim', {'for': 'python'}

" Ctrl-P - press Ctrl-P to open a file
Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_custom_ignore = {'file': '\v\.(o|o\.d)$'}
let g:ctrlp_match_window = 'max:20'
let g:ctrlp_extensions = ['tag', 'line']

Plug 'shaneharper/vim-name_object_after_its_type'

Plug 'shaneharper/vim-code_block_markers'

Plug 'alfredodeza/pytest.vim'
autocmd VimEnter,BufNewFile,BufRead,BufWrite test*.py nnoremap <buffer> <LocalLeader>t :Pytest file<CR>
autocmd VimEnter,BufNewFile,BufRead,BufWrite test*.py nnoremap <buffer> <LocalLeader>T :Pytest function<CR>

Plug 'powerman/vim-plugin-AnsiEsc'

" vital-power-assert (and dependencies).
"  Power assert allows assertions to be written using a "natural" syntax (e.g. "Assert a==b" rather than "call assert_equal('a', 'b')"). (It provides just one command/function.) It generates assertion failure messages that show the name and value of variables used in the assertion as well as values computed by functions.
Plug 'vim-jp/vital.vim'
Plug 'haya14busa/vital-vimlcompiler'
Plug 'haya14busa/vital-power-assert'
Plug 'haya14busa/vital-safe-string'

Plug 'embear/vim-localvimrc'
let g:localvimrc_persistent=2
let g:localvimrc_whitelist=!has('win32') ? ['/home/shane/src/cpppa*', '/mnt/c/Users/shane/source/cpppa']
                                       \ : 'C:\Users\shane\source\cpppa'
let g:localvimrc_sandbox=0
"  A useful .lvimrc, set makeprg to pass project root directory to ninja:
"    set makeprg=ninja\ -C\ \"\$(git\ rev-parse\ --show-toplevel)\"

Plug 'editorconfig/editorconfig-vim'  " .editorconfig files allow for consistent settings in various different editors. Plugins like this one exist for other editors.
let g:EditorConfig_exclude_patterns = ['fugitive://.\*']  " (Recommended by https://github.com/editorconfig/editorconfig-vim)

Plug 'chrisbra/vim-diff-enhanced'  " :PatienceDiff selects the "patience" diff algorithm - this may make some diffs easier to follow.

" zoomwin-vim: <C-W>o toggles fullscreen/windowed.
Plug 'drn/zoomwin-vim'

if !has("win32") || has("win64")  " Don't use YCM if running on Windows with 32-bit Python - see below re. problem building regex library.
    set encoding=utf-8  " As per https://github.com/ycm-core/YouCompleteMe#installation (see "Windows" section).
    Plug 'ycm-core/YouCompleteMe',
                \ {'on': 'YcmCompleter',
                \  'for': ['c', 'cpp', 'cs', 'python'],
                \  'do': !has('win32') ? 'python3 ./install.py --clangd-completer --cs-completer'
                \                     : ' '}  " XXX Add command to install on Windows. Can I just prefix the Linux command with 'vcvars64.bat && '? (https://github.com/ycm-core/YouCompleteMe/issues/1751#issuecomment-407343466 shows one way to do it, but I suspect it can be done more simply.)
        " To build the YCM binary on Windows with Visual Studio 2022 installed:
        "  REM Note the following may not work with 32-bit Python installed. It didn't work for me with YCM d4343e8384... from 29/8/'22. Building the regex library failed, e.g. "unresolved external symbol __imp_PyTupleNew". I suspect the regex library was being built as 64-bit.
        "  python %userprofile%/.vim/plugged/YouCompleteMe/install.py --clangd-completer --cs-completer --msvc 17
    autocmd InsertLeave * if bufname("%") != "[Command Line]" | pclose | endif | " (Command Line check is to silence Vim error message.)
    let g:ycm_auto_hover=''  " Disable automatically showing documentation in a popup at the cursor location after a delay. Popups usually get in the way of reading what is near the cursor location. YCM 9309f777 unnecessarily shows a popup when the cursor is on the name of an entity where it's defined. <plug>(YCMHover) shows the popup.
    let g:ycm_extra_conf_globlist=['~/src/add_vim_script_end_statements/*']
    nnoremap <leader>jd :YcmCompleter GoToDeclaration<CR>
    nnoremap <leader>dt :YcmCompleter GetType<CR>
endif

" numsign provides commands for jumping to lines marked with a 'sign' - YouCompleteMe uses 'signs' on lines causing compilation warnings/errors.
"  \sn or <F2> jumps to next line with a 'sign'.
Plug 'vim-scripts/numsign.vim'
autocmd BufWinEnter,WinEnter * let b:sign_work_mode=0

" Unimpaired: ]q is :cnext, [q is :cprevious, ]l is :lnext, ]l is :lprevious, etc.
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'

" vim-togglelist: <leader>q toggles quickfix window, <leader>l toggles location list
Plug 'milkypostman/vim-togglelist'

"    Plug 'Syntastic'	" awesome syntax and errors highlighter

Plug 'Vimjas/vim-python-pep8-indent'

Plug 't9md/vim-choosewin'
nmap - <Plug>(choosewin)

" dwm.vim - Tiled Window Management for Vim
" XXX disabled 'cause it moves location list windows around.  Plug 'spolu/dwm.vim'

if 0
Plugin 'kien/rainbow_parentheses.vim'  | " This messes up highlighting of multi-line C++11 raw strings.  {{{
au VimEnter * RainbowParenthesesToggle " Turn on "rainbow parentheses".
au Syntax * RainbowParenthesesLoadRound  " xxx PlugInstall will trigger this autocmd to fire before the plugin is installed resulting in "E492: Not an editor command: RainbowParenthesesLoadRound". Don't add this autocmd until after the plugin is installed.
"au Syntax * RainbowParenthesesLoadSquare
"au Syntax * RainbowParenthesesLoadBraces
" }}}
endif

" Argtextobj.vim: daa = delete argument in C function signature, cia = change "inner" argument (exclude comma), ...
Plug 'vim-scripts/argtextobj.vim'

Plug 'tpope/vim-commentary'
autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s

call plug#end()
if s:run_PlugInstall | PlugInstall | endif
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
" Ensure t_Co is set correctly for the Windows version of Vim. {{{
if &term == "win32"
    let &t_Co=max([256, &t_Co])  " By default &t_Co is 16. (Windows Terminal v1.17.11461.0, Vim 9.0 run from Windows Command Prompt and also vim.exe run from WSL/Ubuntu). xxx Shouldn't Vim set &t_Co to be at least 256 when it's run in Windows Terminal? (And then there'd be no need to set t_Co here.) See "set_color_count(tgetnum("Co"));" in Vim's src/term.c? Note: t_Co is also set to 16 when using the cmder terminal (https://cmder.app/); cmder seems to support 256 colors as well.
endif
" }}}

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
    autocmd FileType diff,git,gitcommit,hgcommit,markdown,text set linebreak wrap
    autocmd BufNewFile,BufRead,BufWrite *.swg setfiletype swig
    autocmd BufNewFile,BufRead,BufWrite *.csproj set tabstop=2 shiftwidth=2
    autocmd BufWinEnter * call <SID>set_formatoptions_for_buffer()  " This autocmd is executed after ftplugin scripts have run. (This way we can override unwanted formatoptions settings that may have been made by an ftplugin script.)
    autocmd BufNewFile,BufRead,BufWrite .clang-tidy set filetype=yaml
    autocmd BufNewFile,BufRead,BufWrite .hgignore set filetype=gitignore
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
set lazyredraw
set title
set titleold=  | " Default: "Thanks for flying Vim".  We clear titleold to avoid "Thanks for flying Vim" being briefly displayed when Vim exits before a new title is set, e.g. as specified by the PS1 environment variable used by bash.

" xxx only set relativenumber while in normal mode?
autocmd BufWinEnter,WinEnter * setlocal relativenumber
autocmd WinLeave * setlocal norelativenumber
function LessInitFunc()  " called by $VIMRUNTIME/macros/less.vim
    set norelativenumber
endfunc

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
