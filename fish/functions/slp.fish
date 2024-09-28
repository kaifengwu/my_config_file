function slp --wraps='systemctl suspend -i' --description 'alias slp=systemctl suspend -i'
  systemctl suspend -i $argv; 
end
