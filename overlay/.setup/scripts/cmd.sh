#!/bin/sh
#
#  cmd.sh
#  Run shell command on inotifywait file events.
#
#  Copyright 2020, Marc S. Brooks (https://mbrooks.info)
#

#
# Accepts script arguments.
#
help_menu() {
cat <<EOT
Usage: cmd.sh [-f file]

Options:
  -f : specify the shell command file
EOT
  exit 1
}

while getopts "f:" opt
do
  case "$opt" in
    f)
      CMD_FILE="$OPTARG"
      ;;

    : )
      help_menu
      ;;
  esac
done

if [ -z "$CMD_FILE" ]
then
  help_menu
fi

log_file=/var/log/setup.log

#
# Create output log.
#
if [ ! -e $log_file ]
then
  touch $log_file
fi

#
# Run shell command.
#
while read -r file event
do
  if [ -e $file ]
  then
    cmd=`echo $line | grep -v '[/\\&|;()^\`<>$]'`

    cat $CMD_FILE >> $log_file
    sh  $CMD_FILE >> $log_file 2>&1

    truncate -s 0 $CMD_FILE
  fi
done