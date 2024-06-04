PS1='${debian_chroot:+($debian_chroot)}\[\033[01;38;5;29m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
PS1+='\[\e]2;\w\a\]'  # Set window title.


# Version Control Aliases and Functions ---------------------------------- {{{

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
      grep -v "^--- a/" --text |
      grep -v "^+++ b/" --text |
    # Delete carriage return characters.
    #   vimless displays a carriage return as "^M" colored using the SpecialKey highlighting group. When viewing changes to a file with DOS format line endings I prefer not to see ^M at the end of every line.  XXX Don't filter out a carriage return that appears in a line for file 'a' but not in the corresponding line for file 'b' (or vice versa).
      tr -d '\r'
}

pipe_if_not_empty()  # Initially copied from https://superuser.com/a/210141.
{
    head=$(dd bs=1 count=1 status=none; echo a)
    head=${head%a}
    if [ "x$head" != x"" ]; then
        { printf %s "$head"; cat; } | "$@"
    fi
}

# xxx The following functions should return the return code of the first command ("git diff", "hg diff", etc.) when that command fails. vimless shouldn't be run if the first command fails - It seems that that is what normally happens anyway; in the case of the first command failing usually nothing is output to stdout and consequently pipe_if_not_empty() won't run vimless.
gd() { git diff "$@" | clean_up_vc_diff | pipe_if_not_empty vimless; }
gsh() { git show "$@" | clean_up_vc_diff | pipe_if_not_empty vimless; }
hgd() { hg diff "$@" | clean_up_vc_diff | pipe_if_not_empty vimless; }
hge() { hg export --template "commit {node}{ifeq(branch, 'default', '', '  {branch}')}
{date|rfc822date}{ifeq(author|email, 'shane@shaneharper.net', '', '  {author|email}')}
{indent(desc, '    ')}

{diff}" "$@" | clean_up_vc_diff | pipe_if_not_empty vimless; }

# ------------------------------------------------------------------------ }}}


alias vim='vim -X'  # -X stops Vim connecting to the X server at startup. This can avoid a noticeable delay when starting Vim, e.g. when starting Vim from the WSL preview from the Microsoft Store and it's necessary to wait for WSLg to start if it wasn't running already.

stty -ixon  # disable Xon/Xoff flow control (so Ctrl-S functions as Ctrl-R but searches in the opposite direction).

. ~/bin/z/z.sh


# vim:foldmethod=marker
