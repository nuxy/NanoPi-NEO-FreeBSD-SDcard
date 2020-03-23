# NanoPi-NEO-FreeBSD-SDcard

FreeBSD OS service configurations, scripts, and related dependencies.

## Dependencies

### `make install`

    /usr/pkgsrc/databases/sqlite3
    /usr/pkgsrc/devel/git
    /usr/pkgsrc/lang/nodejs
    /usr/pkgsrc/lang/npm (see workaround below)
    /usr/pkgsrc/sysutils/pwgen

### NPM install workaround

    $ cd /usr/pkgsrc/lang/npm
    $ make configure
    $ cd work/cli-x.x.x/scripts
    $ sh install.sh

## Post-install

### Add more swap to a running system

    $ dd if=/dev/zero of=/swap bs=1m count=4096
    $ chmod 600 /swap
    $ swapctl -a -p 1 /swap

This can also be enabled in [/etc/fstab](etc/fstab)

## Reset device password

    boot> boot netbsd -s
    Enter pathname of shell or RETURN for sh:

    $ mount -uw /
    $ passwd
    $ reboot
