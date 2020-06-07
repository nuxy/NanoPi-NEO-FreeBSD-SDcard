#!/bin/sh
#
#  wpa.sh
#  Configure wireless networking.
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
Usage: wpa.sh [-s ssid] [-p password]

Options:
  -s : specify the wireless network SSID
  -p : specify the wireless network password
EOT
  exit 1
}

while getopts "s:p:" opt
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

if [ -z "$SSID"     ] ||
   [ -z "$PASSWORD" ]
then
  help_menu
fi

ap_conf=/etc/wpa_supplicant.conf

#
# Configure wireless network.
#
revert_file $ap_conf

PASSWORD=`psk_gen $SSID $PASSWORD`

update_config "SSID"     $SSID     $ap_conf
update_config "PASSWORD" $PASSWORD $ap_conf

#
# Restart network services.
#
restart_service netif
