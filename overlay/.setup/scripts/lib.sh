#!/bin/sh
#
#  lib.sh
#  Shorthand functions of common operations.
#
#  Copyright 2020, Marc S. Brooks (https://mbrooks.info)
#

LOG_FILE=/var/log/nanopi-neo.log

#
# Log the message to a file.
#
# Parameters:
#   message
#     String $1
#
log() {
  if [ ! -e $LOG_FILE ]
  then
    touch $LOG_FILE
    chmod 600 $LOG_FILE
  fi

  echo -e "$(date)\t$1" >> $LOG_FILE
}

#
# Generate an encrypted WPA-PSK passphrase.
#
# Parameters:
#   ssid
#     String $1
#
#   password
#     String $2
#
psk_gen() {
  wpa_passphrase $1 $2 | awk 'FNR == 4 {print $1}' | tr -d 'psk='
}

#
# Stop/disable service by name.
#
# Parameters:
#   name
#     String $1
#
disable_service() {
  sed -i '' "s/$1=YES/$1=NO/g" /etc/rc.conf
  service $1 onestop

  log "Disabled service: $1"
}

#
# Start/enable service by name.
#
# Parameters:
#   name
#     String $1
#
enable_service() {
  sed -i '' "s/$1=NO/$1=YES/g" /etc/rc.conf
  service $1 onerestart

  log "Enabled service: $1"
}

#
# Delete file by name.
#
# Parameters:
#   filename
#     String $1
#
delete_config() {
  rm -f /etc/$1

  log "Removed file: $1"
}

#
# Restart the device.
#
restart_device() {
  shutdown -r now
}

#
# Reset filename with system defaults.
#
# Parameters:
#   filename
#     String $1
#
revert_file() {
  git reset HEAD $1
  git checkout $1

  log "Reverted file: $1"
}

#
# Update file(s) matched value(s).
#
# Parameters:
#   key
#     String $1
#
#   value
#     String $2
#
#   filename(s)
#     String $3,$4 ..
#
update_config() {
  for file in "$@"
  do
    if [ -e $file ]
    then
      sed -i '' "s/#$1#/$2/g" $file

      log "Updated file: $file (key/value [$1/$2])"
    fi
  done
}

#
# Write value(s) to file.
#
# Parameters:
#   value
#     String $1
#
#   filename
#     String $2
#
write_config() {
  cat << EOF > $2
$1
EOF

  log "Created file: $1"
}
