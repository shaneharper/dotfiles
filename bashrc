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

simplify_diff_file_headers()
{
    awk '
    # Replace "git --diff a/file b/file" with "==== file ====",
    #     and "git --diff a/old b/new" with "==== old -> new ====" (for a rename).
    /^diff --git / {
        if (match($0, /a\/(.*) b\/(.*)/, m)) {
            a = m[1]; b = m[2]
            print "==== " a (a == b ? "" : " -> " b) " ===="
            next
        }
    }
    # filter out lines that repeat details from a "diff --git" line.
    /^(--- a\/|\+\+\+ b\/|rename (from|to) )/ { next }
    { print }'
}

clean_up_git_diff()
{
      simplify_diff_file_headers |
    # Delete carriage return characters.
    #   vimless displays a carriage return as "^M" colored using the SpecialKey highlighting group. When viewing changes to a file with DOS format line endings I prefer not to see ^M at the end of every line.  XXX Don't filter out a carriage return that appears in a line for file 'a' but not in the corresponding line for file 'b' (or vice versa).
      tr -d '\r'
}

view_git_format_diff()  # $@ = command that produces a git-format diff.
{
    local out; out=$("$@") || return
    [ -z "$out" ] && return 0
    clean_up_git_diff <<<"$out" | vimless
}

gd()  { view_git_format_diff git diff "$@"; }
gsh() { view_git_format_diff git show "$@"; }
hgd() { view_git_format_diff hg diff --git "$@"; }
hge() { view_git_format_diff hg export --git --template "commit {node}{ifeq(branch, 'default', '', '  {branch}')}
{date|rfc822date}{ifeq(author|email, 'shane@shaneharper.net', '', '  {author|email}')}
{indent(desc, '    ')}

{diff}" "$@"; }

# ------------------------------------------------------------------------ }}}


alias ag="ag --color-line-number '37;3'"   # 37 = "light grey" ("not intense" white), 3 = italic.  "Light grey" will be hard to read on a white background with some terminal color schemes such as the "One Half Light" and "Tango Light" Microsoft Terminal color schemes.

alias vim='vim -X'  # -X stops Vim connecting to the X server at startup. This can avoid a noticeable delay when starting Vim, e.g. when starting Vim from the WSL preview from the Microsoft Store and it's necessary to wait for WSLg to start if it wasn't running already.

vimless() { $(vim -es '+put=$VIMRUNTIME|print|quit!')/macros/less.sh $@; }

stty -ixon  # disable Xon/Xoff flow control (so Ctrl-S functions as Ctrl-R but searches in the opposite direction).

. ~/bin/z/z.sh


# vim:foldmethod=marker
