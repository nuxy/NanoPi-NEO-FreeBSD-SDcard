case ${BOARD} in
	NanoPi-NEO2)
		TARGET=aarch64 # A5-Cortex, 64-bit
		;;
	NanoPi-NEO)
		TARGET=arm # A3-Cortex, 32-bit
		;;
esac

board_setup ${BOARD}

option ImageSize 3000mb
option SwapFile 1000mb deferred file=/swap

IMGNAME=FreeBSD.img

# Build overrides.
SRCCONF=${PWD}/overlay/etc/src.conf

# Kernel overrides.
__MAKE_CONF=${PWD}/overlay/etc/make.conf

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

	# Set-up device dependencies.
	chroot . ${qemu_static_bin} /bin/sh .setup/scripts/make.sh

	umount dev

	rm ${qemu_static_bin#?}
}
