#!/bin/sh
#
#  hostap.sh
#  Configure host access point.
#
#  Copyright 2020, Marc S. Brooks (https://mbrooks.info)
#

BASE_DIR=/.setup/scripts
. $BASE_DIR/lib.sh

#
# Accepts script arguments.
#
help_menu() {
cat <<EOT
Usage: hostap.sh [-i ip address] [-g gateway] [-n netmask]
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

ap_conf=/etc/hostapd.conf
if_conf=/etc/ifconfig.wlan0
ip_conf=/etc/hosts
gateway=/etc/mygate

#
# Configure wireless network.
#
revert_file $ap_conf
revert_file $if_conf
revert_file $ip_conf
revert_file $gateway

PASSWORD=$(psk_gen $SSID $PASSWORD)

update_config "IP_ADDR"  $IP_ADDR  $if_conf $ip_conf
update_config "NETMASK"  $NETMASK  $if_conf
update_config "SSID"     $SSID     $ap_conf
update_config "PASSWORD" $PASSWORD $ap_conf

write_config $GATEWAY $gateway

#
# Enable network services.
#
enable_service netif
enable_service hostapd

restart_device
