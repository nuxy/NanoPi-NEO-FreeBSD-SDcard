# NanoPi-NEO-FreeBSD-SDcard

FreeBSD OS service configurations, scripts, and related dependencies.

## Supported boards

- [NanoPi-NEO LTS V1.4](https://www.friendlyarm.com/index.php?route=product/product&product_id=132)
- [NanoPi-NEO Air LTS](https://www.friendlyarm.com/index.php?route=product/product&product_id=151)
- [NanoPi-NEO2](https://www.friendlyarm.com/index.php?route=product/product&product_id=180)

## Dependencies

- SanDisk Ultra microSDXC UHS-I (8 GB)

## Installation

Install package dependencies using [gmake](https://www.gnu.org/software/make).

    $ make <neo|neo-air|neo2>

## Mounting the SD card

### boot

    $ mount -t msdos /dev/da1s1 /mnt

### freebsd

    $ mount -t ufs /dev/da1s2a /mnt

## Run the ARM environment

    $ cp /usr/local/bin/qemu-${TARGET}-static /mnt/usr/local/bin/qemu-${TARGET}-static
    $ chroot /mnt /usr/local/bin/qemu-${TARGET}-static /bin/sh

Commands to do this are outlined [here](https://github.com/nuxy/NanoPi-NEO-FreeBSD-SDcard/-/blob/master/config.sh#L52).

## Troubleshooting

## Reset device password

    boot> boot freebsd -s
    Enter pathname of shell or RETURN for sh:

    $ mount -uw /
    $ passwd
    $ reboot

## Linux DHCP/DNS issues

    $ vi /etc/NetworkManager/NetworkManager.conf

    #dns=dnsmasq

    $ service network-manager restart

## Resources

- [Allwinner H3 Quad-Core ARM Cortex-A7](https://sunxi.org/H3)
- [Allwinner H3 Quad-Core ARM Cortex-A53](https://sunxi.org/H5)
- [U-Boot](https://github.com/u-boot/u-boot)
- [FreeBSD/ARM Project](https://www.freebsd.org/platforms/arm.html)
