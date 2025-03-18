#function copy --wraps='xclip -selection clipboard' --description 'alias copy=xclip -selection clipboard'
#xclip -selection clipboard $argv; 
#end

function copy --wraps='xclip -selection clipboard' --description 'Copy input to clipboard, supports pipes and arguments'
  if test -t 0  # 检测是否有管道输入
    echo $argv | xclip -selection clipboard  # 复制参数
  else
    xclip -selection clipboard  # 复制管道输入
  end
end
