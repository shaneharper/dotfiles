alias vim='vim -X'  # -X stops Vim connecting to the X server at startup. This can avoid a noticeable delay when starting Vim, e.g. when starting Vim from the WSL preview from the Microsoft Store and it's necessary to wait for WSLg to start if it wasn't running already.

alias gst='git status'
alias hga='hg add'
alias hgc='hg commit'
alias hgh='hg heads -v'
alias hgl='hg log -v --follow'
alias hgr='hg revert'
alias hgs='hg status --copies'

function gd() { git diff "$@" | vimless; }
function hgd() { hg diff "$@" | vimless; }
function hge() { hg expo "$@" | vimless; }

stty -ixon  # disable Xon/Xoff flow control (so Ctrl-S functions as Ctrl-R but searches in the opposite direction).

. ~/bin/z/z.sh
