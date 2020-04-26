# NanoPi-NEO-FreeBSD-SDcard

FreeBSD OS service configurations, scripts, and related dependencies.

## Supported boards

- [NanoPi-NEO LTS V1.4](https://www.friendlyarm.com/index.php?route=product/product&product_id=132)
- [NanoPi-NEO2](https://www.friendlyarm.com/index.php?route=product/product&path=69&product_id=180)

## Dependencies

- SanDisk Ultra microSDXC UHS-I

## Installation
  
Install package dependencies using [gmake](https://www.gnu.org/software/make). 

    $ BOARD=NanoPi-NEO make

## Troubleshooting

## Reset device password

    boot> boot freebsd -s
    Enter pathname of shell or RETURN for sh:

    $ mount -uw /
    $ passwd
    $ reboot
