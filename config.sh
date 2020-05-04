case ${BOARD} in
	NanoPi-NEO2)
		TARGET=aarch64 # A5-Cortex, 64-bit
		;;
	NanoPi-NEO)
		TARGET=arm # A3-Cortex, 32-bit
		;;
esac

board_setup ${BOARD}

option ImageSize 4000mb
option SwapFile 1000mb deferred file=/swap

IMGNAME=FreeBSD.img
SRCCONF=${PWD}/overlay/etc/src.conf

customize_freebsd_partition() {
	pkg install -y qemu-user-static

	# Enable kernel binary image activator.
	qemu_static_bin="/usr/local/bin/qemu-${TARGET}-static"

	case ${TARGET} in
		aarch64)
			binmiscctl add arm64 --interpreter ${qemu_static_bin} --magic "\x7f\x45\x4c\x46\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7\x00" --mask "\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff" --size 20 --set-enabled
			;;
		arm)
			binmiscctl add armelf --interpreter ${qemu_static_bin} --magic "\x7f\x45\x4c\x46\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00" --mask "\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff" --size 20 --set-enabled
			;;
	esac

	mkdir -p usr/local/bin && cp ${qemu_static_bin} usr/local/bin

	# SD card image OS/application set-up.
	chroot . ${qemu_static_bin} /bin/sh <<EOF
		service ldconfig start

		export ASSUME_ALWAYS_YES=yes

		pkg bootstrap && pkg install git-lite hostapd node npm python2 sqlite3 wpa_supplicant

		npm install --cwd /server --prefix /server --no-audit --no-optional --unsafe

		pw groupadd -g 1973 -n nanopi-neo
		pw useradd  -u 1973 -n nanopi-neo -g nanopi-neo -d /nonexistent -s /sbin/nologin

		chmod 700 /root /server
		chown -R root:wheel /
		chown -R nanopi-neo:nanopi-neo /server

		chflags schg /etc/resolv.conf
EOF

	rm ${qemu_static_bin#?}
}
