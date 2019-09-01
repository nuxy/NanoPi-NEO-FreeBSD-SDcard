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

update_config "SSID"     $SSID     /etc/hostapd.conf
update_config "PASSWORD" $PASSWORD /etc/hostapd.conf

#
# Enable network services.
#
enable_service mdnsd
enable_service dhcpd
enable_service hostapd
