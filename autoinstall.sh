#!/usr/bin/env fish


set files (ls -a ./ | grep -E '(^\.[^.]+$|\.tmux.conf)' |grep -v '\.git$')

for file in $files
    ln -s (pwd)/$file ~/$file # 创建软链接
end

ll -a ~/ | grep '^.*[0-9] \.config$'
if test $status -eq 0
    ln -s (pwd)/fish ~/.config/fish
else 
    mkdir ~/.config
    ln -s (pwd)/fish ~/.config/fish
end
