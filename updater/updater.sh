#!/bin/sh
DEST_PACKAGE="/tmp/gfw.update.tgz"
cd /tmp || exit
# Get update digest
URL="http://raw.githubusercontent.com/phoeagon/gfw-sim/release/releases/digest"
wget ${URL} -O /tmp/gfw.digest
# Test if need to update
diff /etc/gfw.digest /tmp/gfw.digest && exit
PACKAGE=`sed '2q;d' /tmp/gfw.digest`
# Download.
wget ${PACKAGE} -O ${DEST_PACKAGE}
# Check checksum
EXPECTED_DIGEST=`head -1 /tmp/gfw.digest`
echo ${EXPECTED_DIGEST} ${PACKAGE} | md5sum -c || exit
tar xf ${PACKAGE} -C /
# Print Success
echo "OK"
