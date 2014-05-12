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

" Unimpaired: ]q is :cnext, [q is :cprevious, etc.
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
Bundle 'https://github.com/spolu/dwm.vim.git'

Bundle 'https://github.com/kien/rainbow_parentheses.vim'
"au VimEnter * RainbowParenthesesToggle " XXX Uncommenting this messes up highlighting of multi-line C++11 raw strings
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

augroup filetype_c_abbreviations
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
    " Mappings for things in std namespace. The next two letters are the first and last letters of the abbreviated word.
    autocmd FileType cpp
        \ iabbrev <buffer> sct std::cout <<|
        \ iabbrev <buffer> scr std::cerr <<|
        \ iabbrev <buffer> sel std::endl|
        \ iabbrev <buffer> smp std::map|
        \ iabbrev <buffer> ssg std::string|
        \ iabbrev <buffer> svr std::vector|
augroup END
" }}}

" Mappings for working with code enclosed in {}s -------------------------- {{{
function s:add_curly_brackets()
    let is_record_definition = (getline('.') =~# '\(\<class\>\|\<enum\>\|\<struct\>\|\<union\>\)'
                                              \ .'[^)]*$') " [small HACK] Filter out lines contains a ')', e.g. 'struct S* fn()' and 'if (struct S* v = fn())'
    let is_an_assignment = (getline('.') =~# '=$') " Assume "struct initialization", e.g. MyStruct m = { 1,3,3 };
    execute "normal! o{\<CR>}"
    if is_record_definition || is_an_assignment
        normal! a;
    endif
endfunction

"  Ctrl-k : insert {}s (Mnemonic: 'k'urly)
"  (I wanted to use Shift-<CR> but unfortunately it's not possible to map Shift-<CR> to be different to <CR> when running Vim in a terminal window.)
autocmd FileType c,cpp inoremap <buffer> <c-k> <Esc>:call <SID>add_curly_brackets()<CR>O
autocmd FileType c,cpp nnoremap <buffer> <c-k> :call <SID>add_curly_brackets()<CR>O
autocmd FileType c,cpp vnoremap <buffer> <c-k> ><Esc>`<O{<Esc>`>o}<Esc>
" XXX ^ nice to add a ';' after the '}' if line before first line of visual selection is the start of a struct/class/enum/union.

"   Ctrl-j : insert () and {}s after function name for a function that takes no arguments. (Mnemonic: 'j' is beside 'k' on a Qwerty keyboard, and this is similar to Ctrl-k)
autocmd FileType c,cpp inoremap <buffer> <c-j> <Esc>A()<CR>{<CR>}<Esc>O
autocmd FileType c,cpp nnoremap <buffer> <c-j> A()<CR>{<CR>}<Esc>O

"  jj : continue insertion past end of current block (Mnemonic: 'j' moves down in normal mode.)
autocmd FileType c,cpp inoremap <buffer> jj <Esc>]}A<CR>
" }}}

" Mappings for working with vimscript ------------------------------------- {{{
function s:add_vim_end_of_block_statement()
    let block_type = substitute(substitute(getline('.'), " *", "", ""), "[ !].*", "", "")
    execute "normal! oend".block_type
endfunction
autocmd FileType vim inoremap <buffer> <c-k> <Esc>:call <SID>add_vim_end_of_block_statement()<CR>O
autocmd FileType vim nnoremap <buffer> <c-k> :call <SID>add_vim_end_of_block_statement()<CR>O
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
set background=dark
syntax on

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
