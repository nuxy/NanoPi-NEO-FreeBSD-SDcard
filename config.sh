board_setup NanoPi-NEO

option ImageSize 3000mb
option User nanopi-neo

# Runs after FreeBSD partition is built and populated.
customize_freebsd_partition ( ) {
	chown root:wheel /etc/rc.conf
}
