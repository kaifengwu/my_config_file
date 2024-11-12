let g:external_word_list = []
let g:external_module_list = []
let g:external_module_IO = {}


function! s:LoadWordsFromFile(filepath)
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

function! LoadMoudlesFromFile()
    silent !~/gits/dotfiles/.vim/plugin/verilog_module %
    redraw!

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
endfunction

function! s:AutoComplete(findstart, base)
    let first_word = matchstr(getline('.'),'\w\+') 
    if a:findstart == 1
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
        for l:word in g:external_word_list
            let is_in = 1
            let letter_count = LetterCount(l:word)
            if CheckLetterCount(letter_count,letter_count_in) == 1 
                call add(l:matches,l:word)
            endif
        endfor
        for l:word in g:external_module_list
            let is_in = 1
            let letter_count = LetterCount(l:word)
            if CheckLetterCount(letter_count,letter_count_in) == 1 
                call add(l:matches,l:word)
            endif
            if first_word == l:word
                call add(l:matches,l:base . g:external_module_IO[l:word])
            endif
        endfor
        return l:matches
    endif
endfunction

command! -nargs=1 LoadCompletionFile call s:LoadWordsFromFile(<f-args>)

function! TriggerAutoComplete(mode)
    let is_complete = 0
    let words = ""
    let l:matches = []
    if expand('%:e') != 'v'
        return 0
    elseif getline('.')[col('.') - 2] !~ '\w' && getline('.')[col('.') - 3] !~ ')'
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



function! MyAutoFunction()
  let line = getline('.')
  let col = col('.')
  let char_before_cursor = strpart(line, col-2, 1)
  if char_before_cursor =~ '\w' || char_before_cursor == "\b"
      call TriggerAutoComplete(1)
  endif
endfunction

function! LetterCount(word)
  let letter_count = {}
  for i in range(len(a:word))
    let letter = a:word[i]
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

augroup MyAutoGroup
  autocmd!
  autocmd TextChangedI *.v call MyAutoFunction()
augroup END
