#!/bin/sh
#
#  wap.sh
#  Configure wireless access point.
#
#  Copyright 2019, Marc S. Brooks (https://mbrooks.info)
#

BASE_DIR=/home/nanopi-neo/.setup
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

#
# Disable competing services.
#
disable_service wpa_supplicant

#
# Configure wireless network.
#
revert_file /etc/hostapd.conf
revert_file /etc/ifconfig.urtwn0
revert_file /etc/mygate
revert_file /etc/rc.conf

PASSWORD=`psk_gen $SSID $PASSWORD`

update_config "IP_ADDR"  $IP_ADDR  /etc/ifconfig.urtwn0
update_config "NETMASK"  $NETMASK  /etc/ifconfig.urtwn0
update_config "SSID"     $SSID     /etc/hostapd.conf
update_config "PASSWORD" $PASSWORD /etc/hostapd.conf

write_config $GATEWAY /etc/mygate

#
# Enable network services.
#
enable_service network
enable_service mdnsd
enable_service hostapd
enable_service dhcpd
