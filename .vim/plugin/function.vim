function! Annotate() 
    let  l = expand('%:e')
    if l =='c' || l == 'h' || l == 'json' || l =='v'
        if getline('.')[col('.')-1] == '/' || getline('.')[col('.')] == '/'
            call feedkeys("xx",'n')
        else 
            call feedkeys("i//\<ESC>",'n')
        endif
    else
        if getline('.')[col('.')-1] == '"'
            call feedkeys("x",'n')
        else 
            call feedkeys("i\"\<ESC>",'n')
        endif
    endif
endfunction



function! Newline() 
    if getline('.')[col('.')-1] == ';' || getline('.')[col('.')-1] == '}' || getline('.') == '' 
        if getline(line('.')+1) =~ '^\s*$' ||  getline(line('.')+1) =~ '}' 
            call feedkeys("o",'n')
        else
            call feedkeys("a\<Down>",'n')
        endif
    else 
        if getline('.'+1) =~ '^\s*$'
            call feedkeys("a;\<Down>",'n')
        else 
            call feedkeys("a;\<CR>",'n')
        endif
    endif
endfunction

function! Quotation1() 
    if getline('.')[col('.')-1] == '"' 
       call feedkeys("a\"\<ESC>i",'n')
    else 
      call feedkeys("a\"",'n')
    endif
endfunction

function! Quotation2() 
    if getline('.')[col('.')-1] == '<' 
       call feedkeys("a\>\<ESC>i",'n')
    else 
      call feedkeys("a\>",'n')
    endif
endfunction


function! Quotation3() 
    if getline('.')[col('.')-2] == "'" 
        call feedkeys("i",'n')
    else 
        call feedkeys("a",'n')
        echo "hello"
   endif
endfunction

function! Quotation4() 
    if getline('.')[col('.')-2] == ")" || virtcol('.') == 1  
       call feedkeys("a\<space>\<CR>}\<ESC>O",'n')
    else 
      call feedkeys("a\}\<ESC>i",'n')
    endif
endfunction

function! Window()
    echo &filetype
    if &filetype == 'qf'
        cclose
    else
        echo "open"
        execute 'cgetfile' '/tmp/verilator_output.txt'  
        copen 
        redraw!
    endif
endfunction       

function! JumpToClosingParen(mode)
  let line = getline('.')
  let col = col('.')
  let after_cursor = strpart(line, col)
  let before_cursor = strpart(line,0,col-1)
  let reversed_before_cursor = reverse(before_cursor)
 if a:mode == 1 
  if match(after_cursor, '[()]') != -1
    let match_pos = col('.') + match(after_cursor, '[()]') - 1
    call cursor(line('.'), match_pos + 1)
  else
    echo "No parenthesis after cursor"
    call feedkeys("\<right>",'n')
  endif
 else
  if match(reversed_before_cursor, '[()]') != -1
    let match_pos = col('.') - match(reversed_before_cursor, '[()]') - 3
    call cursor(line('.'), match_pos + 1)
  else
    echo "No parenthesis after cursor"
    call feedkeys("\<left>",'n')
  endif
 endif
endfunction
