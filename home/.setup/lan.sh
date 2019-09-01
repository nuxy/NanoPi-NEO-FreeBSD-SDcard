#!/bin/sh
#
#  lan.sh
#  Configure wireless networking.
#
#  Copyright 2019, Marc S. Brooks (https://mbrooks.info)
#

BASE_DIR=/home/nanopi-neo/.setup
. $BASE_DIR/lib.sh

#
# Accepts script arguments.
#
help_menu() {
cat <<EOT
Usage: lan.sh [-i ip address] [-g gateway] [-n netmask]
              [-s ssid] [-p password]
      
Options:
  -i : specify the network IP address
  -g : specify the network gateway IP address
  -n : specify the network mask IP address
  -s : specify the wireless network SSID
  -p : specify the wireless network password
EOT
  exit 1
}

while getopts "i:g:n:s:p:" opt
do
  case "$opt" in
    i)
      IP_ADDR="$OPTARG"
      ;;

    g)
      GATEWAY="$OPTARG"
      ;;

    n)
      NETMASK="$OPTARG"
      ;;

    s)
      SSID="$OPTARG"
      ;;

    p)
      PASSWORD="$OPTARG"
      ;;

    : )
      help_menu
      ;;
  esac
done

if [ -z "$IP_ADDR"  ] ||
   [ -z "$GATEWAY"  ] ||
   [ -z "$NETMASK"  ] ||
   [ -z "$SSID"     ] ||
   [ -z "$PASSWORD" ]
then
  help_menu
fi

#
# Configure wireless network.
#
revert_file /etc/ifconfig.urtwn0
revert_file /etc/mygate
revert_file /etc/rc.conf
revert_file /etc/wpa_supplicant.conf

PASSWORD=`psk_gen $SSID $PASSWORD`

update_config "IP_ADDR"  $IP_ADDR  /etc/ifconfig.urtwn0
update_config "NETMASK"  $NETMASK  /etc/ifconfig.urtwn0
update_config "SSID"     $SSID     /etc/wpa_supplicant.conf
update_config "PASSWORD" $PASSWORD /etc/wpa_supplicant.conf

write_config $GATEWAY /etc/mygate

#
# Disable competing services.
#
disable_service mdnsd
disable_service dhcpd
disable_service hostapd

#
# Enable network services.
#
enable_service wpa_supplicant
