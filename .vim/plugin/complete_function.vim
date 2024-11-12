autocmd CompleteDone * call InsertEndIfNeeded()

function! InsertEndIfNeeded()

    let l:current_pos = getpos('.')
    execute "normal! hh"
    let l:completed_word = expand('<cword>')
    call setpos('.', l:current_pos)

    echo l:completed_word
    if l:completed_word ==# 'begin_end'
        silent! call feedkeys("\<ESC>?\\w\<CR>dwdwdwdwoend\<ESC>O", 'n')
    elseif l:completed_word ==# '_endcase'
        silent! call feedkeys("\<ESC>?\\w\<CR>dwdwdwdwdwdwdwdwoendcase\<ESC>ki", 'n')
    elseif l:completed_word =~ '___'
        silent! call feedkeys("\<ESC>?\\w\<CR>xxxxa\(\)\<left>", 'n')
    elseif l:completed_word =~ '\()\)'
        silent! call feedkeys("\<ESC>^wwwwa", 'n')
    elseif l:completed_word =~ ');'
        silent! call feedkeys("\<ESC>^wwwwa", 'n')
    endif
    echo l:completed_word
endfunction
