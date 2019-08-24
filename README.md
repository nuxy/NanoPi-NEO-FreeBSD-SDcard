# NanoPi-NEO-NetBSD-SDCard

NetBSD OS service configurations, scripts, and related dependencies.

NetBSD ARM Bootable Images [https://www.invisible.ca/arm](https://www.invisible.ca/arm)

## Dependencies

### `make install`

    /usr/pkgsrc/database/sqlite3
    /usr/pkgsrc/devel/git
    /usr/pkgsrc/lang/nodejs
    /usr/pkgsrc/lang/npm *see workaround

## Post-install

### Adding more swap to a running system

    $ dd if=/dev/zero of=/swap bs=1m count=2048
    $ chmod 600 /swap
    $ swapctl -a -p 1 /swap

This can also be enabled in [/etc/fstab](etc/fstab)

### NPM install workaround

    $ cd /usr/pkgsrc/lang/npm
    $ make configure
    $ cd work/cli-x.x.x/scripts
    $ sh install.sh
