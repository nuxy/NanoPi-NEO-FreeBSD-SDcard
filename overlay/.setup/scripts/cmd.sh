#!/bin/sh
#
#  cmd.sh
#  Run shell command on inotifywait file events.
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

#
# Run shell command.
#
while read -r file event
do
  if [ -e $file ]
  then
    cmd=`cat $CMD_FILE | grep -E -v '[/\\&|;()^\`<>$]|\.\.' | grep -E -i -w '^hostap|lan|wpa'`

    if [ -n "$cmd" ]
    then
      log "Running command ($CMD_FILE)-> $cmd"

      trap log "Error" ERR

      sh $BASE_DIR/$cmd
    fi

    truncate -s 0 $CMD_FILE
  fi
done
