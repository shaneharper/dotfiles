hi clear
if exists("syntax_on") | syntax reset | endif

let colors_name = "sgh"


" XXX Define a light theme and a dark theme; set colors according to &background.

highlight CursorLine cterm=NONE ctermbg=darkblue ctermfg=white guibg=darkblue guifg=white  " One reason for doing this was the default cursorline (an underline) didn't appear on the last line of a buffer on Mac OS X 10.10 (vim 7.4), while this works.
highlight LineNr ctermfg=DarkGrey
highlight Special ctermfg=magenta

" filetype=diff. {{{
"  Note that Vim's diff mode uses different highlight groups to those set here. (Vim's diff mode uses DiffAdd DiffChange, etc.).
highlight diffAdded ctermfg=green guifg=green
highlight diffRemoved ctermfg=red guifg=red
" }}}

highlight! def link vimCommentString vimComment  " (By default vimCommentString was linked to vimString.)

function s:no_syntax_highlighting_for(highlight_group)
    execute "highlight clear" a:highlight_group  | " Clear color and style attributes. Links defined with ":highlight link" are also cleared but links defined with ":highlight default link" are not.
    execute "highlight link" a:highlight_group "NONE"  | " Remove link, if any. (":highlight clear" won't remove a link defined with ":highlight default link" but this will.)
endfunction

function s:clear_unwanted_syntax_highlighting()
    " Some syntax highlighting is useful, e.g. to tell comments from executable statements, but I find a lot of the default syntax highlighting pointless and distracting.

    for highlight_group in ['Statement', 'Number', 'Type', 'Identifier']
        call s:no_syntax_highlighting_for(highlight_group)
    endfor

    " xxx Remove "unwanted" syntax rules. Note though that calling s:no_syntax_highlighting_for() above seems to work pretty well most of the time so there's really little reason to remove unwanted syntax rules.
    " --- Reasons to remove unwanted syntax rules: ---
    "   1/. trivial performance improvement (?)
    "   2/. fixes syntax highlighting where within a syntax group a match of an unwanted syntax group can occur.
    "       Calling s:no_syntax_highlighting_for() above "hides" the syntax highlighting of unwanted syntax groups where synstack() returns [an_unwanted_highlight_group_id], but not, for example, where synstack() returns [Comment_id, an_unwanted_highlight_group_id] (it'll appear no syntax highlighting is used where the Comment highlight group should be used.)
    "           Vim's dosbatch syntax file defines dosBatchComment as "containing" (see :help :syn-contains) @dosbatchNumber. Vim's C syntax highlighting can optionally highlight strings and numbers within a comment but by default it does not.
    " --- Possible implementations: ---
    "   1/. A vim plugin.
    "       Find all highlight groups that link to an unwanted highlight group - hlget() could be used.
    "       :syn clear {all unwanted highlight groups including links}
    "       Use Syntax autocmd to trigger the steps above.
    "   2/. A utility that filters syntax files.
    "       Determine all direct and indirect links to unwanted highlight groups using the "highlight default link" lines in the original syntax file.
    "       Remove all "syn match" lines that use an unwanted highlight group (include links).
    "       Place output in ~/.vim/syntax.

    highlight helpHyperTextJump term=underline cterm=bold ctermfg=14 guifg=#40ffff  | " Normally helpHyperTextJump links to Identifier. (We clear Identifier.)
endfunction

call s:clear_unwanted_syntax_highlighting()


" vim:set foldmethod=marker:
