let g:error_messages = {}
let g:error_messages_2 = {}
function! LoadErrorMessage()
    "清空错误信息

    execute 'sign unplace *'

    let g:error_messages = {}
    let g:error_messages_2 = {}
    let l:error_file='/tmp/verilator_output.txt'
    sign define ErrorSign text=x texthl=Error
    highlight ErrorUnderline cterm=underline gui=underline guifg=Green guibg=NONE
    if !filereadable(l:error_file)
        return
    endif
    for line in readfile(l:error_file)
        let line_tmp = line
        if line =~ '\v\s*(.+):(\d+):(\d+):(.*)'
            let l:errmsg = substitute(line, '\v^[^:]+\.v:([0-9]+):([0-9]+): (.*)','\3','') 
            let l:filename = trim(matchstr(line, '\v([^:]+)\.v',1))
            let l:line = str2nr(substitute(line, '\v^[^:]+\.v:([0-9]+):[0-9]+: .*','\1','')) 
            let l:col = str2nr(substitute(line_tmp, '\v^[^:]+\.v:[0-9]+:([0-9]+): .*','\1','')) 

            if !has_key(g:error_messages, l:filename)
                let g:error_messages[l:filename] = {}
            endif
            if !has_key(g:error_messages_2, l:filename)
                let g:error_messages_2[l:filename] = {}
            endif
            execute 'sign place ' . l:line . ' line=' . l:line . ' name=ErrorSign file=' . l:filename
            call matchadd('Error', '\%' . l:line . 'l\%' . l:col . 'c', 100, -1, {'ctermbg': 'red', 'guibg': 'red'})
            execute 'highlight link ErrorColumn ErrorMsg'
            let g:error_messages[l:filename][l:line] = l:errmsg
            let g:error_messages_2[l:filename][l:line] = l:col
        endif
    endfor
    echo $error_messages
endfunction

function! ShowErrorPopup()
    let l:filename = expand('%:t')
    let l:name = expand('%:p')
    let l:line_num = line('.')
    let l:col_num = col('.')
    let l:popup_handles = popup_list()
    highlight pop ctermbg=blue  ctermfg=black guibg=green guifg=black gui=bold,italic
        for handle in l:popup_handles
                call popup_clear(handle)
         endfor

    if has_key(g:error_messages[l:filename], l:line_num) && abs(l:col_num - g:error_messages_2[l:filename][l:line_num]) <= 2 
        let l:message = [g:error_messages[l:filename][l:line_num]]

        call popup_create(l:message,{
                    \ 'line': 'cursor+1',
                    \ 'col': 'cursor+4',
                    \ 'maxwidth': 60,
                    \ 'maxheight': 10,
                    \ 'minheight': 1,
                    \ 'minwidth': 30,
                    \ 'padding': [0, 1, 0, 1],
                    \ 'border': [0,0,0,0],
                    \ 'title' : 'ERROR:',
                    \ 'highlight' : 'pop',
                    \ 'zindex': 10})
        echo "error"
    else
        echo "No error message found for this line"

    endif
endfunction

