if status is-interactive
    # Commands to run in interactive sessions can go here
end
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
set -gx PATH $JAVA_HOME/bin $PATH
# <<< coursier install directory <<<
