#!/bin/bash

cd ~/.proxy_manager
file="proxy_list.txt"
temp="temp_list.txt"
flag=0

proxyDisable(){
    unset {http,https,ftp}_proxy
    sudo gsettings set org.gnome.system.proxy mode 'none'
}

if [ $EUID -ne 0 ]; then
    echo "Please run as root"
    exec sudo "$0" "$@"
fi

echo "Permission achieved"

while getopts ":adrchov" opt; do
    case $opt in 

        a) 
            flag=1; #Adds the entered network and proxy 
            shift 1
            ;;

        d)
            flag=2; #Removes the stored proxy details of the given ssid
            shift 1
            ;;

        r)
            flag=3; # Removes all stored proxy details
            shift 1
            ;;
        
        c)
            flag=4; # Adds current proxy details to the currently connected ssid
            shift 1
            ;;

        o)
            flag=5; # Deactivates all active proxies
            shift 1
            ;;

        v)
            flag=6; # Views currentlu active proxy profile
            shift 1
            ;;

        h)
            flag=-1;
            shift 1
            ;;

        \?)
            flag=-1;
            shift 1
            ;;
    esac

done

if [ $flag -eq 0 ]; then
    . ./proxy_manager.sh

elif [ $flag -eq 1 ]; then
    if [ $# -eq 3 ]; then
        write_config="\"$1\",'$2',$3"
        echo $write_config >> $file
    else
        echo "Please enter SSID PROXY PORT in the given order"
        exit
    fi

    echo "Supplied information added to registry ! "

elif [ $flag -eq 2 ]; then
    config_to_remove="$1"
    while read -r line
    do
        [[ ! $line =~ $config_to_remove ]] && echo "$line"
    done < $file > $temp
    mv $temp $file

    echo "Performed the required action ! "

elif [ $flag -eq 3 ]; then
    > $file
    echo "Registry empty ! "

elif [ $flag -eq 4 ]; then
    proxy="$(gsettings get org.gnome.system.proxy.https host)"
    port="$(gsettings get org.gnome.system.proxy.https port)"
    interface_id="$(ls /sys/class/net | grep w)"
    cur_network="$(iwconfig $interface_id | grep 'ESSID' | grep -oh '\".*\"')"

    write_config="$cur_network,$proxy,$port"
    echo $write_config >> $file
    echo "Current network details added to registry"

elif [ $flag -eq 5 ]; then
    proxyDisable
    echo "Proxy disabled"

elif [ $flag -eq 6 ]; then
    proxy="$(gsettings get org.gnome.system.proxy.https host)"
    port="$(gsettings get org.gnome.system.proxy.https port)"
    interface_id="$(ls /sys/class/net | grep w)"
    cur_network="$(iwconfig $interface_id | grep 'ESSID' | grep -oh '\".*\"')"

    echo "SSID: $cur_network"
    echo "Proxy: $proxy"
    echo "Port: $port"

fi 