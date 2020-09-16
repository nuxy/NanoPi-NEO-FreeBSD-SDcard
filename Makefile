BUILD_DIR ?= /tmp/crochet
BOARD     ?= NanoPi-NEO
BOARD_DIR ?= $(BUILD_DIR)/board/$(BOARD)

.if $(BOARD) == NanoPi-NEO
    uboot_pkg_name=u-boot-nanopi_neo
.endif

.if $(BOARD) == NanoPi-NEO2
    uboot_pkg_name=u-boot-nanopi-neo2
.endif

all:
	# Install dependencies.
	pkg install -y rsync sqlite3 u-boot-tools $(uboot_pkg_name)

	# Fetch OS build sources.
	svn co svn://svn.freebsd.org/base/release/12.1.0 /usr/src

	# Override DTB installers.
	cp $(PWD)/$(BOARD)/Makefile /usr/src/sys/modules/dtb/allwinner

	# Fetch build tool.
	git clone https://github.com/freebsd/crochet $(BUILD_DIR)

	# Copy board sources.
	cp -r $(PWD)/$(BOARD) $(BOARD_DIR)
	cp -r $(PWD)/overlay  $(BOARD_DIR)

	# Sync application sources.
	rsync -a -m --exclude={.*,*.md,test} $(PWD)/../server $(BOARD_DIR)/overlay/nanopi-neo

	# Build the disk image.
	sh $(BUILD_DIR)/crochet.sh -b $(BOARD) -c config.sh

	# Update the SD card.
	gpart destroy -F da1 && dd if=$(BUILD_DIR)/work/FreeBSD.img of=/dev/da1 bs=1m

	# Cleanup
	rm -rf $(BUILD_DIR)

neo:
	BOARD=NanoPi-NEO make all

neo2:
	BOARD=NanoPi-NEO2 make all
