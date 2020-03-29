board_setup NanoPi-NEO

option ImageSize 3000mb
option User nanopi-neo

customize_freebsd_partition ( ) {
    chown -R root:wheel loader.conf
    chown -R root:wheel etc
    chown -R root:wheel home
}
