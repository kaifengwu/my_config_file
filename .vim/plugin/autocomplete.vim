let g:external_word_list = []
let g:external_module_list = []
let g:external_variable_list = []
let g:external_module_IO = {}


function! s:LoadWordsFromFile(filepath)"抓常用词的函数
    let g:external_word_list = []
    if !filereadable(a:filepath)
        echo "文件未找到:"  . a:filepath
        return
    endif
    let l:content = readfile(a:filepath)
    let l:words = []
    for l:line in l:content
        let l:words += filter(split(l:line, '[^a-zA-Z0-9$_]+'),'v:val != "" && v:val != " "')
    endfor
    let g:external_word_list = uniq(sort(l:words))
endfunction

function! LoadMoudlesFromFile()"抓模块的函数和变量
    silent! execute '!~/.vim/plugin/verilog_module ' . expand('%') . ' ' . line('.')
    silent! redraw!

    let g:external_module_list = []
    let g:external_module_IO = {}
    if !filereadable("./tmp")
        return
    endif
    let l:content = readfile("./tmp")
    let l:words = []
    for l:line in l:content
        if l:line !~ '[()]'
           call add(l:words,l:line)
        else 
            let line_tmp = ' ' . line
            let l:function_name = matchstr(l:line_tmp,'\v^([^\(]+)',1) 
            let l:line = substitute(l:line,'\v^[a-zA-Z$_0-9]+','','')
            let g:external_module_IO[l:function_name] = l:line
        endif
    endfor
    let g:external_module_list = uniq(sort(l:words))
    silent! execute '!rm tmp'

    let g:external_variable_list = []
    let l:content = readfile("./tmp_variable")
    let l:words = []
    for l:line in l:content
        let l:words += filter(split(l:line, '[^a-zA-Z0-9$_]+'),'v:val != "" && v:val != " "')
    endfor
    let g:external_variable_list = uniq(sort(l:words))
    silent! execute '!rm tmp_variable'
endfunction


function! s:AutoComplete(findstart, base)          "把模糊搜索的补全词语放入补全库的函数
    let first_word = matchstr(getline('.'),'\w\+') "行首词语，检测这里是否需要实例化模块
    if a:findstart == 1                            "模式1，用于返回光标所在字符第一个字母位置
        let l:start = col('.') - 1
        while l:start > 0 && getline('.')[l:start - 1] =~ '\k'
            let l:start -= 1
        endwhile
        return l:start
    else
        let l:matches = []
        let l:base = substitute(a:base, '\s\+', '', 'g') 
        let letter_count = {}
        let letter_count_in = LetterCount(l:base)
        
        if CheckWord(1)
            return l:matches
        endif

        for l:word in g:external_module_list      "优先加载模块，模块里除了变量，其他不进行补全
            let letter_count = LetterCount(l:word)
            if first_word == l:word
                let l:matches = []
                if IsCursorInParens()
                    for l:variable in g:external_variable_list
                        let variable_count = LetterCount(l:variable)
                        if CheckLetterCount(variable_count,letter_count_in) == 1 
                            call add(l:matches,l:variable)
                        endif
                    endfor
                    return l:matches
                endif
                call add(l:matches,l:base . g:external_module_IO[l:word])
                return l:matches
            endif
            if CheckLetterCount(letter_count,letter_count_in) == 1 
                call add(l:matches,l:word)
            endif
        endfor

        if CheckWord(0)
            let l:matches = []
        endif


        for l:variable in g:external_variable_list "加载变量，只包括光标所在模块的变量
            let variable_count = LetterCount(l:variable)
            if CheckLetterCount(variable_count,letter_count_in) == 1 
                call add(l:matches,l:variable)
            endif
        endfor

        if CheckWord(0)
            return l:matches
        endif

        for l:word in g:external_word_list "加载补全单词
            let letter_count = LetterCount(l:word)
            if CheckLetterCount(letter_count,letter_count_in) == 1 
                call add(l:matches,l:word)
            endif
        endfor
        return l:matches
    endif
endfunction

command! -nargs=1 LoadCompletionFile call s:LoadWordsFromFile(<f-args>)

function! TriggerAutoComplete(mode)"加入补全列表，还有判断是否需要调用补全函数(return 0就是不需要)
    let is_complete = 0
    let words = ""
    let l:matches = []
    if expand('%:e') != 'v'
        return 0
    "elseif getline('.')[col('.') - 2] !~ '\w' && getline('.')[col('.') - 3] !~ ')'&& getline('.')[col('.') - 2] !~ ']'
    elseif !pumvisible() && a:mode == 0
        return 0
    endif
    if col('.') > 1
        let l:line = getline('.')
        let l:col = col('.')
        let l:word_start = l:col - 1 
        while strcharpart(getline('.'),l:word_start - 1,1) =~ '\k' && l:word_start >= 0
            let l:word_start -= 1 
        endwhile 
        let words = matchstr(l:line, '\k\+', l:word_start)
        let l:matches = s:AutoComplete(0,words )
        let l:start = s:AutoComplete(1,words)
        if len(l:matches) > 0
            if a:mode == 1
                call complete(l:start+1,l:matches)
            endif
            return 1
        else 
            return 0 
        endif
    else
        return 0
    endif

endfunction

function! Verilogformat()
    silent! execute '!touch tmp_format;
                \verible-verilog-format %>tmp_format;
                \cat tmp_format>%;
                \rm tmp_format;'
    redraw!
endfunction




function! LetterCount(word)
  let letter_count = {}
  for i in range(len(a:word))
    let letter = a:word[i]
    if letter =~# '^[A-Z]$'
        let letter = tolower(letter)
    endif
    if has_key(letter_count, letter)
      let letter_count[letter] += 1
    else
      let letter_count[letter] = 1
    endif
  endfor
  return letter_count
endfunction

function! CheckLetterCount(arr1, arr2)
  for [letter, letter_count] in items(a:arr2)
    if !has_key(a:arr1, letter) || a:arr1[letter] < letter_count
      return 0
    endif
  endfor
  return 1
endfunction

function! CheckWord(mode)
    let first_word = matchstr(getline('.'),'\w\+') "行首词语
    let first_word_list_1 = ['input','output','inout','reg','wire']
    let first_word_list_2 = ['posedge','negedge']
    let l:pos = getcurpos()
    let l:search_pos = search('\w\+', 'bW')
    call search('\w\+','bW')
    let before_word = expand('<cword>')
    call setpos('.',l:pos)
    if a:mode == 1
        for l:word in first_word_list_1
            if first_word =~ l:word
                return 1
            endif
        endfor
        return 0
    elseif a:mode == 0
        for l:word in first_word_list_2
            if IsCursorInParens() && before_word =~ l:word || first_word =~ 'assign'
                return 1
            endif
        endfor

        return 0
    else 
        return 0
    endif
endfunction

function! IsCursorInParens()
  let line = getline('.')
  let col = col('.')
  let before_cursor = strpart(line, 0, col-1)
  let after_cursor = strpart(line, col-1)

  if match(before_cursor, '[({[]') != -1 && match(after_cursor, '[)}\]]') != -1
    return 1 " 光标在括号内
  else
    return 0 " 光标不在括号内
  endif
endfunction



augroup MyAutoGroup
  autocmd!
  autocmd TextChangedI *.v call MyAutoFunction()
augroup END

function! MyAutoFunction()
  let line = getline('.')
  let col = col('.')
  let char_before_cursor = strpart(line, col-2, 1)
  if char_before_cursor =~ '\w' || char_before_cursor == "\b"
      call TriggerAutoComplete(1)
  endif
endfunction
