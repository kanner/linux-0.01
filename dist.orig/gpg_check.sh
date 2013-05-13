#!/bin/bash

gunzip -c linux-0.01.tar.gz >linux-0.01.tar

### get DSA (for tarballs) and RSA (for sha256sums) keys
gpg --keyserver subkeys.pgp.net --recv-keys 517D0F0E 589DA6B1

#gpg --edit-key ftpadmin@kernel.org trust
#gpg --edit-key autosigner@kernel.org trust

### check the tarball signature and delete it
gpg --verify linux-0.01.tar.sign
if [ $? -ne 0 ]; then
	echo "Integrity check failed for linux-0.01.tar"
	rm linux-0.01.tar
	exit 1
fi
rm linux-0.01.tar

### check the tar/gz signature
gpg --verify linux-0.01.tar.gz.sign
if [ $? -ne 0 ]; then 
        echo "Integrity check failed for linux-0.01.tar.gz"
	exit 1
fi

### check sha256sums signature
gpg sha256sums.asc
if [ $? -ne 0 ]; then
        echo "Integrity check failed for sha256sums.asc"
	exit 1
fi

### check checksum
sha256sum ./linux-0.01.tar.gz 2>&1 | diff - sha256sums
if [ $? -ne 0 ]; then
        echo "Wrong checksum for linux-0.01.tar.gz"
	rm sha256sums
	exit 1
fi
rm sha256sums

echo "Seems everything's fine"
exit 0
