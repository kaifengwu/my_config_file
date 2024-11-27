let g:error_messages = {}
let g:error_messages_2 = {}

function! LoadErrorMessage()"加载错误信息
    "清空错误信息

    execute 'sign unplace *'
    call clearmatches()

    let g:error_messages = {}
    let g:error_messages_2 = {}
    let g:warning_messages = {}
    let g:warning_messages_2 = {}
    if g:ERROR_MODULE == 0
        return
    endif
    let l:error_file='/tmp/verilator_output.txt'
    sign define ErrorSign text=✘ texthl=Error
    sign define WarningSign text=❗ texthl=Warning
    highlight Error cterm=underline gui=underline guifg=Green guibg=red
    highlight Warning cterm=underline gui=underline guifg=blue guibg=red ctermfg = white ctermbg = blue
    if !filereadable(l:error_file)  
        return
    endif
    for line in readfile(l:error_file)
        let line_tmp = line
        if line =~ '\v\s*(.+):(\d+):(\d+):(.*)' && match(line,'Error') > 0
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
            execute 'highlight link ErrorColumn Error'
            let g:error_messages[l:filename][l:line] = l:errmsg
            let g:error_messages_2[l:filename][l:line] = l:col
        elseif line =~ '\v\s*(.+):(\d+):(\d+):(.*)' && match(line,'Warning') > 0
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
            execute 'sign place ' . l:line . ' line=' . l:line . ' name=WarningSign file=' . l:filename
            call matchadd('Warning', '\%' . l:line . 'l\%' . l:col . 'c', 100, -1, {'ctermbg': 'red', 'guibg': 'red'})
            execute 'highlight link ErrorColumn Warning'
            let g:error_messages[l:filename][l:line] = l:errmsg
            let g:error_messages_2[l:filename][l:line] = l:col
        endif
    endfor
endfunction

function! ShowErrorPopup()"展示错误信息
    let l:popup_handles = popup_list()
    for handle in l:popup_handles
            call popup_clear(handle)
    endfor
    let l:filename = expand('%:t')
    let l:name = expand('%:p')
    let l:line_num = line('.')
    let l:col_num = col('.')

    highlight pop ctermbg=blue  ctermfg=black guibg=green guifg=black gui=bold,italic
    if g:error_messages == {} 
        return
    endif

    if has_key(g:error_messages[l:filename], l:line_num)
        if abs(l:col_num - g:error_messages_2[l:filename][l:line_num]) <= 2 
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
                    \ 'title' : 'ERROR/Warning:',
                    \ 'highlight' : 'pop',
                    \ 'zindex': 10})
        endif
        echo "Error or Warning in this line"
    else
        echo "No error or warning message found for this line"
    endif
endfunction

function! ShowVariablePopup()"展示变量信息
    let l:popup_handles = popup_list()
    for handle in l:popup_handles
            call popup_clear(handle)
    endfor
    let l:word = expand('<cword>')
    if has_key(g:external_variable_property, l:word) && getline('.')[col('.') - 1] =~ '\w'
        let l:message = [g:external_variable_property[l:word]]
            call popup_create(l:message,{
                    \ 'line': 'cursor+1',
                    \ 'col': 'cursor+4',
                    \ 'maxwidth': 60,
                    \ 'maxheight': 10,
                    \ 'minheight': 1,
                    \ 'minwidth': 30,
                    \ 'padding': [0, 1, 0, 1],
                    \ 'border': [1,1,1,1],
                    \ 'title' : 'Message:',
                    \ 'highlight' : 'pop',
                    \ 'zindex': 10})
    endif
endfunction

function! ShowPopup()
    if g:ERROR_MODULE == 1
        call ShowErrorPopup()
    elseif g:ERROR_MODULE == 0
        call ShowVariablePopup()
    endif
endfunction

function! LoadQuickfixMessage()
    silent! execute '!~/.vim/plugin/verilog_function/verilog_quickfix'  expand('%') . ' ' .g:ERROR_MODULE
    silent! call LoadErrorMessage()                                                                                                                                                     
    silent! redraw!                                                                                                                                                                     
    silent! call LoadMoudlesFromFile(0)    
endfunction

function! ModuleChange()
    let g:ERROR_MODULE = !g:ERROR_MODULE
    if g:ERROR_MODULE == 1
        echo "Display Error"
    elseif g:ERROR_MODULE == 0
        echo "Display Message"
    endif
endfunction
