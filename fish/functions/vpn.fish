function vpn --wraps='. /bin/openvpn' --description 'alias vpn=. /bin/openvpn'
  . /bin/openvpn $argv; 
end
