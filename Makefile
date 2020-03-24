all:
	# Install dependencies
	pkg install -y u-boot-nanopi-neo

	# Fetch OS build sources.
	svn co svn://svn.freebsd.org/base/release/12.1.0 /usr/src

	# Fetch build tool.
	git clone https://github.com/freebsd/crochet /tmp/crochet

	# Link system sources.
	ln -s /vagrant/sdcard/NanoPi-NEO /tmp/crochet/board

	# Build the disk image.
	sh /tmp/crochet/crochet.sh -c config.sh
	dd if=`ls /tmp/crochet/work/*.img` of=/dev/da1 bs=1m

	# Cleanup
	rm -rf /tmp/crochet
