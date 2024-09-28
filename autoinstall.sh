#!/usr/bin/env fish


set files (ls -a ./ | grep -E '(^\.[^.]+$|\.tmux.conf)' |grep -v '\.git$')

for file in $files
    ln -s (pwd)/$file ~/$file # 创建软链接
end
     
