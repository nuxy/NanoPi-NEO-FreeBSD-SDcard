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

chflags schg /etc/resolv.conf /usr/local/etc/dhcpd.conf /usr/local/etc/unbound/unbound.conf

#
# Install FreeBSD ports.
#
export ASSUME_ALWAYS_YES=yes

pkg bootstrap
pkg install dhcpd git-lite hostapd inotify-tools libsass node npm python2 screen sqlite3 unbound

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
git add -f /etc/hostapd.conf /etc/hosts /etc/ifconfig.* /etc/mygate /etc/wpa_supplicant.conf /nanopi-neo/.setup
git commit -m 'Initial set-up'

#
# Remove unused files/directories.
#
rm -rf .profile .snap \
	/etc/bluetooth /etc/dma /etc/mail /etc/make.conf /etc/ppp /etc/src.conf /etc/X11 /etc/zfs \
	/home /media /mnt /net /proc /usr/share/games \
	/var/at /var/games /var/log/.snap /var/run/ppp /var/spool

#
# Remove unused user/groups.
#
pw groupdel dialer ftp hast
pw userdel  games hast mailnull man news pop smmsp uucp www
