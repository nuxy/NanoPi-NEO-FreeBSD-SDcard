KERNCONF=GENERIC
UBLDR_LOADADDR=0x42000000
SUNXI_UBOOT=u-boot-nanopi_neo
SUNXI_UBOOT_BIN=u-boot-sunxi-with-spl.bin
UBOOT_PATH=/usr/local/share/u-boot/${SUNXI_UBOOT}
TARGET_ARCH=armv7
FREEBSD_SRC=/usr/src
IMAGE_SIZE=$((1000 * 1000 * 1000))

npi_dts_dir=/usr/src/sys/gnu/dts/arm
npi_dts_file_base=sun8i-h3-nanopi-neo
npi_dts_full_path=${npi_dts_dir}/${npi_dts_file_base}.dts

allwinner_partition_image() {
	echo "Installing U-Boot from: ${UBOOT_PATH}"

	dd if=${UBOOT_PATH}/${SUNXI_UBOOT_BIN} conv=notrunc,sync of=/dev/${DISK_MD} bs=1024 seek=8

	disk_partition_mbr
	disk_fat_create 32m 16 1m
	disk_ufs_create
}

allwinner_check_uboot() {
	uboot_port_test ${SUNXI_UBOOT} ${SUNXI_UBOOT_BIN}
}

make_workaround_fdt() {
	mkdir -p ${WORKDIR}/npi

	cmd=`echo MACHINE=arm /usr/src/sys/tools/fdt/make_dtb.sh ${FREEBSD_SRC}/sys ${npi_dts_full_path} ${WORKDIR}/npi`
	sh -c "$cmd"
	echo $cmd

	if [ $? != 0 ]; then
		echo "make_workaround_fdt: Command failed."
		exit 1
	fi
}

copy_workaround_fdt() {
	destdir=$1

	echo "Copy device tree (dtb) to: ${destdir}/${npi_dts_file_base}.dtb"

	if [ x = "x$destdir" ]; then
		echo "copy_workaround_fdt: Needs a destination directory argument."
		exit 1
	fi

	case "x$destdir" in
		xboot)
			destdir=${BOARD_BOOT_MOUNTPOINT}
			;;
		xbsd)
			destdir=${BOARD_FREEBSD_MOUNTPOINT}/boot/dtb
			;;
	esac

	if [ ! -d $destdir ]; then
		echo "copy_workaround_fdt: $destdir is not a directory."
		exit 1
	fi

	cp ${WORKDIR}/npi/${npi_dts_file_base}.dtb ${destdir}/${npi_dts_file_base}.dtb
}

make_boot_install_boot_scr_file() {
	echo "echo \"Loading U-boot loader: ubldr.bin\"" > ${BOARD_BOOT_MOUNTPOINT}/boot.cmd
	echo "load \${devtype} \${devnum}:${distro_bootpart}" "${UBLDR_LOADADDR}" ubldr.bin >> ${BOARD_BOOT_MOUNTPOINT}/boot.cmd
	echo "go ${UBLDR_LOADADDR}" >> ${BOARD_BOOT_MOUNTPOINT}/boot.cmd

	mkimage -A arm -T script -C none -n "Boot Commands" -d ${BOARD_BOOT_MOUNTPOINT}/boot.cmd ${BOARD_BOOT_MOUNTPOINT}/boot.scr
}

strategy_add $PHASE_PARTITION_LWW allwinner_partition_image
strategy_add $PHASE_CHECK allwinner_check_uboot
strategy_add $PHASE_BUILD_OTHER freebsd_ubldr_build UBLDR_LOADADDR=${UBLDR_LOADADDR}
strategy_add $PHASE_BOOT_INSTALL freebsd_ubldr_copy_ubldr .
strategy_add $PHASE_BOOT_INSTALL make_workaround_fdt
strategy_add $PHASE_BOOT_INSTALL copy_workaround_fdt boot
strategy_add $PHASE_FREEBSD_BOARD_INSTALL copy_workaround_fdt bsd
strategy_add $PHASE_FREEBSD_BOARD_INSTALL make_boot_install_boot_scr_file

# Put the kernel on the FreeBSD UFS partition.
strategy_add $PHASE_FREEBSD_BOARD_INSTALL board_default_installkernel .

# overlay/etc/fstab mounts the FAT partition at /boot/msdos
strategy_add $PHASE_FREEBSD_BOARD_INSTALL mkdir -p boot/msdos

# ubldr help and config files go on the UFS partition (after boot dir exists)
strategy_add $PHASE_FREEBSD_BOARD_INSTALL freebsd_ubldr_copy boot