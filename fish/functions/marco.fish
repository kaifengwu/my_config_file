function marco --wraps='pwd > ~/.config/fish/functions/where.txt' --description 'alias marco=pwd > ~/.config/fish/functions/where.txt'
  pwd > ~/.config/fish/functions/where.txt $argv; 
end
