#!/bin/sh
#
#  make.sh
#  Set-up device dependencies.
#
#  Copyright 2020, Marc S. Brooks (https://mbrooks.info)
#

service ldconfig start

#
# Set-up user/group permissions.
#
pw groupadd -g 1973 -n nanopi-neo
pw useradd  -u 1973 -n nanopi-neo -g nanopi-neo -d /nanopi-neo -s /bin/sh

chmod 755 /.setup/scripts/*.sh
chmod 700 /nanopi-neo /root
chmod 666 /nanopi-neo/.setup
chmod 555 /etc/rc.d/*
chown -R root:wheel /
chown -R nanopi-neo:nanopi-neo /nanopi-neo

chflags schg /etc/resolv.conf /usr/local/etc/dhcpd.conf

#
# Install FreeBSD ports.
#
export ASSUME_ALWAYS_YES=yes

pkg bootstrap && pkg install dhcpd git-lite hostapd inotify-tools libsass node npm python2 screen sqlite3

#
# Install NPM application.
#
mv /nanopi-neo/server/app /nanopi-neo/app && ln -s /nanopi-neo/app /nanopi-neo/server

su nanopi-neo <<EOF
	npm install --cwd /nanopi-neo/app --prefix /nanopi-neo/app
	npm install --cwd /nanopi-neo/server --prefix /nanopi-neo/server
EOF

#
# Save configuration state.
#
git init
git add -f /etc/hostapd.conf /etc/hosts /etc/ifconfig.* /etc/mygate /etc/rc.conf /etc/wpa_supplicant.conf /nanopi-neo/.setup
git commit -m 'Initial set-up'

#
# Remove build/unused files.
#
rm -rf /etc/X11 /etc/make.conf /etc/src.conf /home /media /mnt /net /proc /var/at /var/spool /var/log/maillog

find . -type d \( -name .snap -o -name bluetooth -o -name dma -o -name games -o -name mail -o -name ppp -o -name zfs \) | xargs rm -rf

#
# Remove unused user/groups.
#
pw userdel -y games hast mailnull man news pop smmsp uucp www
pw groupdel -y dialer ftp hast
