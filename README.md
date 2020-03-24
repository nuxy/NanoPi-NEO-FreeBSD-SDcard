# NanoPi-NEO-FreeBSD-SDcard

FreeBSD OS service configurations, scripts, and related dependencies.

## Dependencies

### `make install`

    /usr/ports/databases/sqlite3
    /usr/ports/devel/git
    /usr/ports/lang/nodejs
    /usr/ports/lang/npm
    /usr/ports/sysutils/pwgen

## Post-install

### Add more swap to a running system

    $ dd if=/dev/zero of=/swap bs=1m count=4096
    $ chmod 600 /swap
    $ swapctl -a -p 1 /swap

This can also be enabled in [/etc/fstab](etc/fstab)

## Reset device password

    boot> boot freebsd -s
    Enter pathname of shell or RETURN for sh:

    $ mount -uw /
    $ passwd
    $ reboot
