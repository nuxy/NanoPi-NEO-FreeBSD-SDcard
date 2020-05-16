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

chmod 700 /root /nanopi-neo
chown -R root:wheel /
chown -R nanopi-neo:nanopi-neo /nanopi-neo

chflags schg /etc/resolv.conf

#
# Install FreeBSD ports.
#
export ASSUME_ALWAYS_YES=yes

pkg bootstrap && pkg install git-lite hostapd libsass node npm python2 sqlite3

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
git add -f /etc/hostapd.conf /etc/ifconfig.* /etc/mygate /etc/rc.conf /etc/wpa_supplicant.conf /nanopi-neo/.setup
git commit -m 'Initial set-up'

#
# Cleanup build/unused files.
#
rm -rf /etc/make.conf /etc/src.conf
rm -rf /home /media /mnt /net /proc /usr/share/games /var/games
rm -rf .profile .snap
