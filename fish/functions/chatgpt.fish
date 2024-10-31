function chatgpt --wraps='firefox https://shared.fduer.org/?temporary-chat=true' --wraps='firefox https://plus.fduer.com/' --description 'alias chatgpt=firefox https://plus.fduer.com/'
  firefox https://plus.fduer.com/ $argv; 
end
