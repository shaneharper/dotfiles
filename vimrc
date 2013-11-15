" Set-up Vundle - the vim plugin bundler {{{
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
    
"    Bundle 'Syntastic' "uber awesome syntax and errors highlighter
"    Bundle 'altercation/vim-colors-solarized'
    Bundle 'https://github.com/tpope/vim-fugitive'

    if RunBundleInstall == 1
        echo "Installing Bundles, please ignore key map error messages"
        echo ""
        :BundleInstall
    endif
" }}}
