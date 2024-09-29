function! Annotate() 
    if getline('.')[col('.')-1] == '"'
       call feedkeys("x",'n')
    else 
      call feedkeys("i\"\<ESC>",'n')
    endif
endfunction

