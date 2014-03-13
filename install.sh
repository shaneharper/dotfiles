#!/bin/bash

cd `dirname $0`

ln -s `pwd`/vimrc ~/.vimrc
mkdir -p ~/.vim
cp -r snippets/ ~/.vim

git config --global core.excludesfile ~/dotfiles/gitignore

ln -s `pwd`/hgrc ~/.hgrc
