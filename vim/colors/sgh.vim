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

function Clear_unwanted_syntax_highlighting()
    " Some syntax highlighting is useful, e.g. to tell comments from executable statements, but I find a lot of the default syntax highlighting pointless and distracting.
    " XXX Can the syntax highlighting rules that I don't want be removed, rather than "hiding" their effect via the following? Is this a good start (for vimscript files)?...  syn clear vimLet vimCommand vimFuncName vimFunckey vimOper
    for s:highlight_group in ['Statement', 'Number', 'Type', 'Identifier']
        execute "highlight!" s:highlight_group "NONE"
    endfor

    exec "highlight helpHyperTextJump ".s:original_Identifier_highlight_args
    " exec "highlight helpOption ".s:original_Type_highlight_args
    " exec "highlight helpHeadLine ".s:original_Statement_highlight_args
endfunction

call Clear_unwanted_syntax_highlighting()
autocmd GUIEnter * call Clear_unwanted_syntax_highlighting()  | " xxx Just calling Clear_unwanted_syntax_highlighting() from this script is ineffective when running gvim, but works fine when called from this GUIEnter autocmd. (Vim 8.2 on Ubuntu 16.04) (Calling Clear_unwanted_syntax_highlighting() from this script is effective when running vim in a terminal window.)


" vim:set foldmethod=marker: