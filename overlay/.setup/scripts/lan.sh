#!/bin/sh
#
#  lan.sh
#  Configure local networking.
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
Usage: lan.sh [-i ip address] [-g gateway] [-n netmask]

Options:
  -i : specify the network IP address
  -g : specify the network gateway IP address
  -n : specify the network mask IP address
EOT
  exit 1
}

while getopts "i:g:n:" opt
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

    : )
      help_menu
      ;;
  esac
done

if [ -z "$IP_ADDR" ] ||
   [ -z "$GATEWAY" ] ||
   [ -z "$NETMASK" ]
then
  help_menu
fi

if_conf=/etc/ifconfig.wlan0
ip_conf=/etc/hosts
gateway=/etc/mygate

#
# Configure virtual network.
#
revert_file $if_conf
revert_file $ip_conf
revert_file $gateway

update_config "IP_ADDR"  $IP_ADDR  $if_conf $ip_conf
update_config "NETMASK"  $NETMASK  $if_conf

write_config $GATEWAY $gateway

#
# Disable competing services.
#
disable_service hostapd

restart_device
