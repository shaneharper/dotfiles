PS1='${debian_chroot:+($debian_chroot)}\[\033[01;38;5;29m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

alias vim='vim -X'  # -X stops Vim connecting to the X server at startup. This can avoid a noticeable delay when starting Vim, e.g. when starting Vim from the WSL preview from the Microsoft Store and it's necessary to wait for WSLg to start if it wasn't running already.

alias gst='git status'
alias hga='hg add'
alias hgc='hg commit'
alias hgh='hg heads -v'
alias hgl='hg log -v --follow'
alias hgr='hg revert'
alias hgs='hg status --copies'

clean_up_vc_diff()
{
    # Delete unified diff headers.
    #   A unified diff header is not normally required as the names of the files that were compared are already output in a line like "diff --git a/PATH_A b/PATH_B".  xxx Don't remove lines that start with "---a /" or "+++ b/" that are not part of a unified diff header.
      grep -v "^--- a/" |
      grep -v "^+++ b/" |
    # Delete carriage return characters.
    #   vimless displays a carriage return as "^M" colored using the SpecialKey highlighting group. When viewing changes to a file with DOS format line endings I prefer not to see ^M at the end of every line.  XXX Don't filter out a carriage return that appears in a line for file 'a' but not in the corresponding line for file 'b' (or vice versa).
      tr -d '\r'
}

# xxx Don't run vimless in the following functions if the first command exits with an error.
gd() { git diff "$@" 2>&1 | clean_up_vc_diff | vimless; }
gsh() { git show "$@" 2>&1 | clean_up_vc_diff | vimless; }
hgd() { hg diff "$@" 2>&1 | clean_up_vc_diff | vimless; }
hge() { hg expo "$@" 2>&1 | clean_up_vc_diff | vimless; }

stty -ixon  # disable Xon/Xoff flow control (so Ctrl-S functions as Ctrl-R but searches in the opposite direction).

. ~/bin/z/z.sh
