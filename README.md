# NanoPi-NEO-FreeBSD-SDcard

FreeBSD OS service configurations, scripts, and related dependencies.

## Supported boards

- [NanoPi-NEO LTS V1.4](https://www.friendlyarm.com/index.php?route=product/product&product_id=132)
- [NanoPi-NEO2](https://www.friendlyarm.com/index.php?route=product/product&path=69&product_id=180)

## Dependencies

- SanDisk Ultra microSDXC UHS-I

## Installation

Install package dependencies using [gmake](https://www.gnu.org/software/make).

    $ make <neo|neo2>

## Mounting the SD card

### boot

    $ mount -t msdos /dev/da1s1 /mnt

### freebsd

    $ mount -t ufs /dev/da1s2a /mnt

## Run the ARM environment

    $ cp /usr/local/bin/qemu-${TARGET}-static /mnt/usr/local/bin/qemu-${TARGET}-static
    $ chroot /mnt /usr/local/bin/qemu-${TARGET}-static /bin/sh

Yommands to do this are outlined [here](https://github.com/nuxy/NanoPi-NEO-FreeBSD-SDcard/-/blob/develop/config.sh#L36).

## Troubleshooting

## Reset device password

    boot> boot freebsd -s
    Enter pathname of shell or RETURN for sh:

    $ mount -uw /
    $ passwd
    $ reboot
