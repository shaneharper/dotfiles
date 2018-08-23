#!/bin/bash

cd `dirname $0`


ln -s `pwd`/vimrc ~/.vimrc


git config --global core.excludesfile `pwd`/gitignore
git config --global push.default simple

ln -s `pwd`/hgrc ~/.hgrc


function append_if_not_already_in_file
{
    FILENAME=$1
    TEXT=$2
    grep -q --line-regexp "$TEXT" "$FILENAME" || echo "$TEXT" >> "$FILENAME"
}

append_if_not_already_in_file ~/.bashrc "export EDITOR=vim"
append_if_not_already_in_file ~/.bashrc 'export MAKEFLAGS="$MAKEFLAGS -j`getconf _NPROCESSORS_ONLN`"'
append_if_not_already_in_file ~/.bashrc 'stty -ixon  # disable Xon/Xoff flow control (so Ctrl-S functions as Ctrl-R but searches in the opposite direction).'
