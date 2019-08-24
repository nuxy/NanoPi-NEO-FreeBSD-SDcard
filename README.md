# NanoPi-NEO-NetBSD-SDCard

NetBSD OS service configurations, scripts, and related dependencies.

NetBSD ARM Bootable Images [https://www.invisible.ca/arm](https://www.invisible.ca/arm)

## Post-install

### Adding more swap to a running system

    $ dd if=/dev/zero if=/swap bs=1m count=2048
    $ chmod 600 /swap
    $ swapctl -a -p 1 /swap

This can also be enabled in [/etc/fstab](etc/fstab)

### NPM install workaround

    $ cd /usr/pkgsrc/lang/npm
    $ make configuration
    $ cd work/cli-x.x.x/scripts
    $ sh install.sh
