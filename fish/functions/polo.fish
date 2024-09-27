function polo --wraps='cd (cat ~/.config/fish/functions/where.txt)' --description 'alias polo=cd (cat ~/.config/fish/functions/where.txt)'
  cd (cat ~/.config/fish/functions/where.txt) $argv; 
end
