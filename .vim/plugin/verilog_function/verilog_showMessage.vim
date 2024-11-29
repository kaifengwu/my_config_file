let g:error_messages = {}
let g:error_messages_2 = {}
let g:before_line = 0
let g:jump = 0

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
highlight pop ctermbg=black ctermfg=blue guibg=green guifg=black gui=bold,italic

function! ShowErrorPopup()"展示错误信息
    let l:popup_handles = popup_list()
    for handle in l:popup_handles
            call popup_clear(handle)
    endfor
    let l:filename = expand('%:t')
    let l:name = expand('%:p')
    let l:line_num = line('.')
    let l:col_num = col('.')

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
let g:variable_message_IO = ''
let g:variable_IO = {}

function! ShowVariablePopup()"展示变量信息
    let l:popup_handles = popup_list()

    for handle in l:popup_handles
            call popup_clear(handle)
    endfor
    let g:word = expand('<cword>')
    "展示变量对应的信息
    if has_key(g:external_variable_property, g:word) && getline('.')[col('.') - 1] =~ '\w'
        if g:external_variable_property[g:word] =~ '-PARAMETER-'
            let g:variable_IO = [g:external_variable_property[g:word]]
        elseif g:variable_message_IO !=#  g:word
            let g:variable_IO = {}
            let g:variable_message_IO = g:word
            silent! execute '!~/.vim/plugin/verilog_function/verilog_variable_message'  expand('%') . ' ' . line('.') . ' ' . g:word
            silent! execute '!sed -i "1i ' . "Your Note: " . shellescape(g:external_variable_property[g:word]) . '" ./variable_message_list'
            let g:variable_IO = readfile("./variable_message_list")
            silent! execute '!rm variable_message_list'
        endif
        call popup_create(g:variable_IO,{
                    \ 'line': 'cursor+1',
                    \ 'col': 'cursor+4',
                    \ 'maxwidth': 80,
                    \ 'maxheight': 10,
                    \ 'minheight': 1,
                    \ 'minwidth': 1,
                    \ 'padding': [0, 1, 0, 1],
                    \ 'border': [1,1,1,1],
                    \ 'title' : 'Message:',
                    \ 'highlight' : 'pop',
                    \ 'zindex': 10})
    elseif has_key(g:external_module_IO, g:word) && getline('.')[col('.') - 1] =~ '\w'
        let g:variable_message_IO = g:word
        let g:jump = 1
        let l:message = "push <C-j>: jump to module " . g:word . " |  then push <C-k> will come back here"
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
    else
        let g:variable_message_IO = g:word "防止你从变量名称到其他地方做了修改，又回到这个名称，变了没修正
        let g:jump = 0
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
    silent! execute 'write'
    if g:ERROR_MODULE == 1
        echo "Display Error"
    elseif g:ERROR_MODULE == 0
        echo "Display Message"
    endif
endfunction

function! JumpToModule(mode)
  let l:current_line = line('$')
  let l:line_now = line('.')
  let l:current_word = expand('<cword>')
  if a:mode == 1
  while l:current_line > 0
    " 获取当前行的内容
    let l:line = getline(l:current_line)
    " 检查行首是否有 'module' 关键字
    if l:line =~# '^\s*module' 
      let l:line = substitute(l:line, '^\s*module\s*', '', '')
      if expand('<cword>') == matchstr(l:line, '\<\k\+') && l:current_line != line('.')
        let g:before_line = line('.')
        execute "normal " . l:current_line . "G"
        echo "go to line " . l:current_line . " module: " . l:current_word 
      elseif l:current_line == line('.')
          echo 'you have been in the module ' . l:current_word 
      endif
    endif
    " 移动到上一行
    let l:current_line -= 1
  endwhile
  " 如果没有找到，返回空字符串
  return ''
  elseif a:mode == 0
        execute "normal " .g:before_line. "G"
        let g:before_line = l:line_now
        echo "come back to " . g:before_line
  endif
endfunction
