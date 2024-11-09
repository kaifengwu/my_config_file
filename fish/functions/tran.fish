function tran --wraps='trans -s en -t zh-CN' --description 'alias tran=trans -s en -t zh-CN'
    set WORD $argv
    trans -s en -t zh-CN $WORD; 
end
