#!/bin/bash

cd `dirname $0`

ln -s `pwd`/vimrc ~/.vimrc

git config --global core.excludesfile ~/dotfiles/gitignore

ln -s `pwd`/hgrc ~/.hgrc
