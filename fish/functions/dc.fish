function dc --wraps=marco --wraps='cd (cat ~/.config/fish/functions/where.txt)' --wraps='marco;cd' --description 'alias dc=marco;cd'
  marco;cd $argv; 
end
