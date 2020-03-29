# NanoPi-NEO-FreeBSD-SDcard

FreeBSD OS service configurations, scripts, and related dependencies.

## Dependencies

### `make install`

    /usr/ports/databases/sqlite3
    /usr/ports/devel/git
    /usr/ports/lang/nodejs
    /usr/ports/lang/npm
    /usr/ports/sysutils/pwgen

## Troubleshooting

## Reset device password

    boot> boot freebsd -s
    Enter pathname of shell or RETURN for sh:

    $ mount -uw /
    $ passwd
    $ reboot
