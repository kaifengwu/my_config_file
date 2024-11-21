autocmd CompleteDone * call InsertEndIfNeeded()

function! InsertEndIfNeeded()

    let l:current_pos = getpos('.')
    execute "normal! hh"
    let l:completed_word = expand('<cword>')
    let l:character = getline('.')[col('.') - 1]
    call setpos('.', l:current_pos)
    let type = 'NULL'

    echo l:completed_word
    if l:completed_word ==# 'begin_end'
        silent! call feedkeys("\<ESC>?\\w\<CR>dwdwdwdwoend\<ESC>O", 'n')
        let type = 'begin_end'
    elseif l:completed_word ==# 'module_endmodule'
        silent! call feedkeys("\<ESC>?\\w\<CR>dwdwdwdwdwdwdwdwdwdwoendmodule\<ESC>ka\<space>", 'n')
        let type = 'module_endmodule'
    elseif l:completed_word ==# '_endcase'
        silent! call feedkeys("\<ESC>?\\w\<CR>dwdwdwdwdwdwdwdwoendcase\<ESC>ki", 'n')
        let type = 'case_endcase'
    elseif l:completed_word =~ '___'
        silent! call feedkeys("\<ESC>?\\w\<CR>xxxxa\(\)\<left>", 'n')
        let type = 'always@()'
    elseif l:completed_word == '())'
        silent! call feedkeys("\<ESC>^wwwwa", 'n')
        let type = 'function'
    elseif l:completed_word == '());'
        silent! call feedkeys("\<ESC>^wwwwa", 'n')
        let type = 'function'
    elseif l:character == ':'
        silent! call feedkeys("\<ESC>?\\w\<CR>la", 'n')
    endif
    echo l:completed_word . '  ' .  l:character . ' ' . type
endfunction
