function tran --wraps='trans -s en -t zh-CN' --description 'alias tran=trans -s en -t zh-CN'
    set b ''
    if test -x /usr/bin/xclip
        set clipboard_command "xclip -o -selection clipboard"
    else if test -x /usr/bin/pbpaste
        set clipboard_command "pbpaste"
    else
        echo "未找到剪贴板工具。请安装 xclip 或 pbpaste。" 
        exit 1
    end

    while true
        # 提示用户输入
        echo "请输入翻译内容："
        # 使用 `read` 命令获取输入，`-l` 标志表示将输入内容保存在 `input` 变量中
        read input
        if test "$input" = "exit" || test "$input" = "q"
            echo "退出程序。"
            break
        else if test "$input" = "b" 
            echo "开启轻量模式。"
            set mode b
            continue
        else if test "$input" = "h" 
            echo "开启完整模式。"
            set mode h 
            continue
        else if test "$input" = "c" 
            echo "开启汉译英模式。"
            set mode c 
            continue
        else if test -z "$input"
            set input (eval $clipboard_command | sed ':a;N;$!ba;s/\n/ /g' )
        end
        set input ( echo -e "$input" | sed ':a;N;$!ba;s/\n/ /g' )
        #输出获取到的输入
        #set text (trans -s en -t zh-CN $input)
        #clear
        echo "原文:"
        echo $input
        echo "译文:"
        if test "$mode" = "b"
            trans -b -s en -t zh-CN $input
        else if test "$mode" = "c"
            trans -s zh-CN -t en  $input
        else
            trans -s en -t zh-CN $input
        end
        #\ | sed 's/Translations of[a-zA-Z0-9\s]+简体中文//g'

        # 1. 删除从 "translations of" 到 "简体中文" 之间的所有内容
        

        # 2. 删除拼音字符（包括带声调的字符）
        # 拼音通常包含字母和带声调的元音（例如 ā, á, ǎ, à 等）
        # 正则匹配拼音（可能有多个字母，包含带声调的元音）
        #set text (echo $text | sed 's/\([a-zA-Zāáǎàēéěèīíǐìōóǒòūúǔùǖǘǚǜ]+\)//g')

        # 输出处理后的文本
        #printf '%s' $text
    end
end

