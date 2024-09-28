function cvpn --wraps=cd/home/kaifeng/.config --description 'close vpn'
export no_proxy=""
export ALL_PROXY=""
export FTP_PROXY=""
export HTTPS_PROXY=""
export HTTP_PROXY=""
export NO_PROXY=""
export all_proxy=""
export ftp_proxy=""
export http_proxy=""
export https_proxy=""
export no_proxy=""
gsettings set org.gnome.system.proxy mode 'none'
set JOB (jobs | grep cfw | awk '{ print $1 }') 
jobs | grep cfw
if test $status -eq 0
    kill %$JOB
    kill %$JOB
end
end
