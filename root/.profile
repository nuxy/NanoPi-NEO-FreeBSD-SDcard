#	$NetBSD: dot.profile,v 1.0 2019/08/15 00:00:00 nuxy Exp $

export PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/pkg/sbin:/usr/pkg/bin
export PATH=${PATH}:/usr/X11R7/bin:/usr/local/sbin:/usr/local/bin
export BLOCKSIZE=1k
export HOST="$(hostname)"
export ENV=/root/.shrc

umask 022
