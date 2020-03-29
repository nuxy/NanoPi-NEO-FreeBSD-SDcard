board_setup NanoPi-NEO

option ImageSize 3000mb
option SwapFile 2000mb deferred file=/swap
option User nanopi-neo
option UsrPorts

customize_freebsd_partition() {
    chown    root:wheel /
    chown -R root:wheel boot
    chown -R root:wheel etc
    chown -R root:wheel home

    chflags schg etc/resolv.conf
}