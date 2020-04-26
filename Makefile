BUILD_DIR ?= /tmp/crochet

all:
	# Install dependencies
	pkg install -y rsync u-boot-nanopi_neo u-boot-tools

	# Fetch OS build sources.
	svn co svn://svn.freebsd.org/base/release/12.1.0 /usr/src

	# Fetch build tool.
	git clone https://github.com/freebsd/crochet $(BUILD_DIR)

	# Link system sources.
	ln -s /vagrant/sdcard/NanoPi-NEO $(BUILD_DIR)/board

	# Sync application sources.
	rsync -a -m --exclude={.*,*.md,test} /vagrant/server NanoPi-NEO/overlay

	# Build the disk image.
	sh $(BUILD_DIR)/crochet.sh -c config.sh

	# Update the SD card.
	gpart destroy -F da1 && dd if=$(BUILD_DIR)/work/FreeBSD.img of=/dev/da1 bs=1m

	# Cleanup
	rm -rf $(BUILD_DIR)
