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

__pager() { pipe_if_not_empty vimless --not-a-term -; }  # (--not-a-term stops Vim displaying "Vim: Reading from stdin...".)


# xxx The following functions should return immediately with the return code of the first command ("git diff", "hg diff", etc.) if that command fails. (Presently if the first command fails without outputting anything to stdout then __pager will return immediately and anything written to stderr will immediately be visible.)
gd() { git diff "$@" | clean_up_vc_diff | __pager; }
gsh() { git show "$@" | clean_up_vc_diff | __pager; }
hgd() { hg diff "$@" | clean_up_vc_diff | __pager; }
hge() { hg export --template "commit {node}{ifeq(branch, 'default', '', '  {branch}')}
{date|rfc822date}{ifeq(author|email, 'shane@shaneharper.net', '', '  {author|email}')}
{indent(desc, '    ')}

{diff}" "$@" | clean_up_vc_diff | __pager; } 

# ------------------------------------------------------------------------ }}}


alias ag="ag --color-line-number '37;3'"   # 37 = "light grey" ("not intense" white), 3 = italic.  "Light grey" will be hard to read on a white background with some terminal color schemes such as the "One Half Light" and "Tango Light" Microsoft Terminal color schemes.

alias vim='vim -X'  # -X stops Vim connecting to the X server at startup. This can avoid a noticeable delay when starting Vim, e.g. when starting Vim from the WSL preview from the Microsoft Store and it's necessary to wait for WSLg to start if it wasn't running already.

vimless() { $(vim -es '+put=$VIMRUNTIME|print|quit!')/macros/less.sh $@; }

stty -ixon  # disable Xon/Xoff flow control (so Ctrl-S functions as Ctrl-R but searches in the opposite direction).

. ~/bin/z/z.sh


# vim:foldmethod=marker
