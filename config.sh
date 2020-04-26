board_setup NanoPi-NEO

option ImageSize 1250mb
option SwapFile 2000mb deferred file=/swap

IMGNAME=FreeBSD.img
SRCCONF=${PWD}/NanoPi-NEO/overlay/etc/src.conf

customize_freebsd_partition() {
	pkg install -y u-boot-qemu-arm

	# Enable kernel binary image activator.
	binmiscctl add armelf --interpreter "/usr/local/bin/qemu-arm-static" --magic "\x7f\x45\x4c\x46\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00" --mask "\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff" --size 20 --set-enabled

	mkdir -p usr/local/bin && cp /usr/local/bin/qemu-arm-static usr/local/bin

	# SD card image OS/application set-up.
	chroot . /usr/local/bin/qemu-arm-static /bin/sh <<EOF
		service ldconfig start

		export ASSUME_ALWAYS_YES=yes

		pkg bootstrap && pkg install git-lite node npm python2 sqlite3

		npm install --cwd /server --prefix /server --no-audit --no-optional --unsafe

		pw groupadd -g 1973 -n nanopi-neo
		pw useradd  -u 1973 -n nanopi-neo -g nanopi-neo -d /nonexistent -s /sbin/nologin

		chmod 700 /root /server
		chown -R root:wheel /
		chown -R nanopi-neo:nanopi-neo /server

		chflags schg /etc/resolv.conf
EOF

	rm usr/local/bin/qemu-arm-static
}
