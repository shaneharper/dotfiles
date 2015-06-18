#!/bin/bash

cd `dirname $0`


ln -s `pwd`/vimrc ~/.vimrc

mkdir -p ~/.vim/after/ftplugin
cat <<EOF > ~/.vim/after/ftplugin/c.vim
" Don't automatically insert the 'comment leader' when starting a new line next to a comment. (I tend not to use // for multi-line comments in C++.)
" See: http://stackoverflow.com/questions/16030639/vim-formatoptions-or/23326474#23326474
setlocal formatoptions-=cro
EOF


git config --global core.excludesfile ~/dotfiles/gitignore

ln -s `pwd`/hgrc ~/.hgrc


function append_if_not_already_in_file
{
    FILENAME=$1
    TEXT=$2
    grep -q --line-regexp "$TEXT" "$FILENAME" || echo "$TEXT" >> "$FILENAME"
}

append_if_not_already_in_file ~/.bashrc "export EDITOR=vim"
append_if_not_already_in_file ~/.bashrc 'export MAKEFLAGS="$MAKEFLAGS -j8"'  # XXX don't hard code number of jobs (e.g. run nproc on Linux).
