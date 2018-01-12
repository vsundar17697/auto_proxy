#!/bin/bash
if [ $EUID -ne 0 ]; then
    echo "Please run as root"
    exec sudo "$0" "$@"
fi

echo "Root permission achieved"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir ~/.proxy_manager
touch ~/.proxy_manager/proxy_list.txt
cp -r $DIR/* ~/.proxy_manager
sudo chown root *
chmod +xwr ~/.proxy_manager/*
cp $DIR/proxy_caller /etc/NetworkManager/dispatcher.d/
chmod +x /etc/NetworkManager/dispatcher.d/proxy_caller

echo "Done initialization"

# rm -rf $DIR
# cp $DIR/proxy_manager.sh /etc/network/if-up.d/proxy_manager
 
# chmod +x /etc/network/if-up.d/proxy_manager
