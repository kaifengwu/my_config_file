if status is-interactive
    # Commands to run in interactive sessions can go here
end


# >>> coursier install directory >>>
set -gx PATH "$PATH:/home/kaifeng/.local/share/coursier/bin"
set -gx JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64
set -gx PATH $JAVA_HOME/bin $PATH
# <<< coursier install directory <<<

function smart_ctrl_l
    if test -n (commandline) 
        commandline -f forward-char # 有输入时向右移动光标
    else
        clear; commandline -f repaint # 无输入时清屏
    end
end

bind \cl smart_ctrl_l  # 绑定 Ctrl-l
set -Ux NVBOARD_HOME /home/kaifeng/ysyx-workbench/nvboard
set -Ux NEMU_HOME /home/kaifeng/ysyx-workbench/nemu

set lock (setxkbmap -query | grep options: | sed  -E 's/options:\s+([a-zA-Z]+):[a-zA-Z]+/\1/g')
# 检查 Caps Lock 键的状态
if not type -q capslock
    #function capslock
    if test $lock != 'caps'
        setxkbmap -option ""
        setxkbmap -layout us,gb -option caps:lock
        echo 'recover capslock';
    end
end

set -gx PATH "$PATH:/home/kaifeng/.cache/scalacli/local-repo/bin/scala-cli"
 
# >>> coursier install directory >>>
set -gx PATH "$PATH:/home/kaifeng/.local/share/coursier/bin"
set -gx JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64
set -gx PATH $PATH /usr/lib/jvm/java-17-openjdk-amd64/bin /home/kaifeng/.fzf/bin /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/games /usr/local/games /snap/bin /snap/bin /home/kaifeng/.cache/scalacli/local-repo/bin/scala-cli /home/kaifeng/.local/share/coursier/bin /home/kaifeng/.local/bin /home/kaifeng/.local/lib/python3.10/site-packages /opt/riscv-linux/bin /home/kaifeng/qemu/build
