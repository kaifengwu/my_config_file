function sysp --wraps='sudo sysctl -p' --description 'alias sysp=sudo sysctl -p'
  sudo sysctl -p $argv; 
end
