board_setup NanoPi-NEO

option ImageSize 3000mb
option User nanopi-neo
option SwapFile 2000mb [deferred] [file=/swap]

customize_freebsd_partition() {
    chown -R root:wheel loader.conf
    chown -R root:wheel etc
    chown -R root:wheel home
}
