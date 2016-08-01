#!/bin/bash

cd `dirname $0`


ln -s `pwd`/vimrc ~/.vimrc


git config --global core.excludesfile `pwd`/gitignore

ln -s `pwd`/hgrc ~/.hgrc


function append_if_not_already_in_file
{
    FILENAME=$1
    TEXT=$2
    grep -q --line-regexp "$TEXT" "$FILENAME" || echo "$TEXT" >> "$FILENAME"
}

append_if_not_already_in_file ~/.bashrc "export EDITOR=vim"
append_if_not_already_in_file ~/.bashrc 'export MAKEFLAGS="$MAKEFLAGS -j`getconf _NPROCESSORS_ONLN`"'
