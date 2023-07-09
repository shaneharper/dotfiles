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

for s:highlight_group in ['Statement', 'Number', 'Type', 'Identifier']
    let s:original_{s:highlight_group}_highlight_args =
        \ execute("highlight ".s:highlight_group)->matchstr('\v\s*xxx\s+\zs.*')
endfor

function s:no_syntax_highlighting_for(highlight_group)
    execute "highlight clear" a:highlight_group  | " Clear color and style attributes. Links defined with ":highlight link" are also cleared but links defined with ":highlight default link" are not.
    execute "highlight link" a:highlight_group "NONE"  | " Remove link, if any. (":highlight clear" won't remove a link defined with ":highlight default link" but this will.)
endfunction

function Clear_unwanted_syntax_highlighting()
    " Some syntax highlighting is useful, e.g. to tell comments from executable statements, but I find a lot of the default syntax highlighting pointless and distracting.
    for highlight_group in ['Statement', 'Number', 'Type', 'Identifier']
        call s:no_syntax_highlighting_for(highlight_group)  | " XXX Remove unwanted syntax highlighting groups as per :help syn-clear rather than trying to "hide" them. (Note that the Normal group will be used - ideally the next item down in the stack of syntax items (as returned by synstack()) should be used as that may be something other than the Normal group.)
    endfor

    exec "highlight helpHyperTextJump" s:original_Identifier_highlight_args
    " exec "highlight helpOption" s:original_Type_highlight_args
    " exec "highlight helpHeadLine" s:original_Statement_highlight_args
endfunction

call Clear_unwanted_syntax_highlighting()
autocmd GUIEnter * call Clear_unwanted_syntax_highlighting()  | " xxx Just calling Clear_unwanted_syntax_highlighting() from this script is ineffective when running gvim, but works fine when called from this GUIEnter autocmd. (Vim 8.2 on Ubuntu 16.04) (Calling Clear_unwanted_syntax_highlighting() from this script is effective when running vim in a terminal window.)


" vim:set foldmethod=marker:
