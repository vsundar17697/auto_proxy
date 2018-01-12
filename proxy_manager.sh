#!/bin/bash

proxyEnable(){
    sudo gsettings set org.gnome.system.proxy.http host $1
    sudo gsettings set org.gnome.system.proxy.http port $2
    sudo gsettings set org.gnome.system.proxy.https host $1
    sudo gsettings set org.gnome.system.proxy.https port $2
    sudo gsettings set org.gnome.system.proxy.ftp host $1
    sudo gsettings set org.gnome.system.proxy.ftp port $2
    sudo gsettings set org.gnome.system.proxy.socks host $1
    sudo gsettings set org.gnome.system.proxy.socks port $2
    export {http,https,ftp}_proxy="$1:$2"
    sudo gsettings set org.gnome.system.proxy mode 'manual'
    return 1
}

disableProxyForTheseAlone(){
    #Proxy will be disabled for these sites
    export no_proxy="localhost,127.0.0.1"
}

proxyDisable(){
    unset {http,https,ftp}_proxy
    sudo gsettings set org.gnome.system.proxy mode 'none'
}

# proxyAuto(){
#     sudo set org.gnome.system.proxy mode 'auto'
#     sudo gsettings set org.gnome.system.proxy autoconfig-url $1
# }


if [ $EUID -ne 0 ]; then
    echo "Please run as root"
    exec sudo "$0" "$@" 
fi

cd ~/.proxy_manager
input="proxy_list.txt"
interface_id="$(ls /sys/class/net | grep w)"
cur_network="$(iwconfig $interface_id | grep 'ESSID' | grep -oh '\".*\"')"
status=0

while IFS=, read ssid proxy port || [[ -n "$ssid" ]]; do
    echo "$ssid $proxy $port" 
    if [[ $cur_network == $ssid ]] || [[ $cur_network == \"$ssid\" ]];then
        proxyEnable $proxy $port
        echo "Proxy set for network $ssid"
        status=1
        break
    fi
done < "$input"

if [ $status -eq 0 ]; then
    echo "Proxy disabled for network $ssid"
    proxyDisable
fi
