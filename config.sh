board_setup NanoPi-NEO

option ImageSize 3000mb
option SwapFile 2000mb deferred file=/swap
option User nanopi-neo
option PackageInit http://pkg.freebsd.org/FreeBSD:12:armv7/quarterly/
option Package node npm sqlite3
option UsrPorts

IMGNAME=FreeBSD.img
SRCCONF=${PWD}/NanoPi-NEO/overlay/etc/src.conf

customize_freebsd_partition() {
	chown    root:wheel / entropy swap
	chown -R root:wheel boot etc home

	chflags schg etc/resolv.conf

	rm -f ${SRCCONF}
}
