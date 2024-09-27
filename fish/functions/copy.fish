function copy --wraps='xclip -selection clipboard' --description 'alias copy=xclip -selection clipboard'
  xclip -selection clipboard $argv; 
end
