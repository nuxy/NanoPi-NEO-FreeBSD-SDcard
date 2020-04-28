BUILD_DIR ?= /tmp/crochet
BOARD     ?= NanoPi-NEO

.if $(BOARD) == NanoPi-NEO2
    uboot=u-boot-nanopi-neo2
.else
    uboot=u-boot-nanopi_neo
.endif

all:
	# Install dependencies.
	pkg install -y rsync u-boot-tools $(uboot)

	# Fetch OS build sources.
	svn co svn://svn.freebsd.org/base/release/12.1.0 /usr/src

	# Fetch build tool.
	git clone https://github.com/freebsd/crochet $(BUILD_DIR)

	# Copy board sources.
	cp -r $(PWD)/$(BOARD) $(BUILD_DIR)/board
	cp -r $(PWD)/overlay  $(BUILD_DIR)/board/$(BOARD)

	# Sync application sources.
	rsync -a -m --exclude={.*,*.md,test} $(PWD)/../server $(BUILD_DIR)/board/$(BOARD)/overlay

	# Build the disk image.
	sh $(BUILD_DIR)/crochet.sh -b $(BOARD) -c config.sh

	# Update the SD card.
	gpart destroy -F da1 && dd if=$(BUILD_DIR)/work/FreeBSD.img of=/dev/da1 bs=1m

	# Cleanup
	rm -rf $(BUILD_DIR)
