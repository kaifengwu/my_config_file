function hcp --wraps='history | fzf | copy' --description 'alias hcp=history | fzf | copy'
  history | fzf | copy $argv; 
end
