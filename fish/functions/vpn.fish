function vpn --wraps=cd/home/kaifeng/.config --description 'open vpn'

    ~/Downloads/Clash\ for\ Windows-0.20.39-x64-linux/cfw &
    gsettings set org.gnome.system.proxy mode 'manual'
    export no_proxy=localhost,127.0.0.0/8,::1
    export ALL_PROXY=socks://127.0.0.1:7890/
    export FTP_PROXY=http://127.0.0.1:7890/
    export HTTPS_PROXY=http://127.0.0.1:7890/
    export HTTP_PROXY=http://127.0.0.1:7890/
    export NO_PROXY=localhost,127.0.0.0/8,::1
    export all_proxy=socks://127.0.0.1:7890/
    export ftp_proxy=http://127.0.0.1:7890/
    export http_proxy=http://127.0.0.1:7890/
    export https_proxy=http://127.0.0.1:7890/
    export no_proxy=localhost,127.0.0.0/8,::1
end
