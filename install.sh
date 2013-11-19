#!/bin/sh

cd `dirname $0`

ln -s `pwd`/vimrc ~/.vimrc
cp -r snippets/ ~/.vim
