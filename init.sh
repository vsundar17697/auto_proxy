if [ $EUID -ne 0 ]; then
    echo "Please run as root"
    exec sudo "$0" "$@"
fi

echo "Root permission achieved"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir ~/.proxy_manager
touch ~/.proxy_manager/proxy_list.txt
cp -r $DIR/* ~/.proxy_manager
chmod -x+wr ~/.proxy_manager/*.txt
chmod +xr-w ~/.proxy_manager/*.sh

echo "Done initialization"
# cp $DIR/proxy_manager.sh /etc/network/if-up.d/proxy_manager
 
# chmod +x /etc/network/if-up.d/proxy_manager
