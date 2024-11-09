function! Annotate() 
    let  l = expand('%:e')
    if l =='c' || l == 'h' || l == 'json'
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
