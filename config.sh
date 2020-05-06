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

	mount -t devfs devfs dev

	# SD card image OS/application set-up.
	chroot . ${qemu_static_bin} /bin/sh <<EOF
		service ldconfig start

		export ASSUME_ALWAYS_YES=yes

		pkg bootstrap && pkg install git-lite hostapd libsass node npm python2 sqlite3 wpa_supplicant

		pw groupadd -g 1973 -n nanopi-neo
		pw useradd  -u 1973 -n nanopi-neo -g nanopi-neo -d /nanopi-neo -s /bin/sh

		rm -rf /home

		chmod 700 /root /nanopi-neo
		chown -R root:wheel /
		chown -R nanopi-neo:nanopi-neo /nanopi-neo

		chflags schg /etc/resolv.conf

		mv /nanopi-neo/server/app /nanopi-neo/app && ln -s /nanopi-neo/app /nanopi-neo/server

		su nanopi-neo -c "npm install --cwd /nanopi-neo/app --prefix /nanopi-neo/app"
		su nanopi-neo -c "npm install --cwd /nanopi-neo/server --prefix /nanopi-neo/server"
EOF

	umount dev

	rm ${qemu_static_bin#?}
}