#!/bin/sh
#
#  wap.sh
#  Configure wireless access point.
#
#  Copyright 2020, Marc S. Brooks (https://mbrooks.info)
#

BASE_DIR=/nanopi-neo/.setup
. $BASE_DIR/lib.sh

#
# Network defaults.
#
IP_ADDR=10.0.0.1
NETMASK=255.255.255.0
GATEWAY=10.0.0.1

#
# Accepts script arguments.
#
help_menu() {
cat <<EOT
Usage: wap.sh [-s ssid] [-p password]

Options:
  -s : specify the wireless network SSID
  -p : specify the wireless network password
EOT
  exit 1
}

while getopts ":s:p:" opt
do
  case "$opt" in
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

if_conf=/etc/ifconfig.wlan1
ip_conf=/etc/hosts
ap_conf=/etc/hostapd.conf
gateway=/etc/mygate

#
# Disable competing services.
#
disable_service wpa_supplicant

#
# Configure wireless network.
#
revert_file $ap_conf
revert_file $if_conf
revert_file $ip_conf
revert_file $gateway

PASSWORD=`psk_gen $SSID $PASSWORD`

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
