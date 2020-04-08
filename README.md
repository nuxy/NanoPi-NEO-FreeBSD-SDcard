# NanoPi-NEO-FreeBSD-SDcard

FreeBSD OS service configurations, scripts, and related dependencies.

## Dependencies

- FriendlyElec / [NanoPi NEO V1.4](https://www.friendlyarm.com/index.php?route=product/product&product_id=132) (512 MB RAM)
- SanDisk Ultra microSDXC UHS-I

## Troubleshooting

## Reset device password

    boot> boot freebsd -s
    Enter pathname of shell or RETURN for sh:

    $ mount -uw /
    $ passwd
    $ reboot
