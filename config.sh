board_setup NanoPi-NEO

option ImageSize 3000mb
option SwapFile 2000mb [deferred] [file=/swap]
option User nanopi-neo
option UsrPorts

customize_freebsd_partition() {
    chown -R root:wheel loader.conf
    chown -R root:wheel etc
    chown -R root:wheel home
}
