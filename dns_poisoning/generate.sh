#!/bin/sh
DEAD="59.24.3.173"
BLACKLIST=`cat blacklist.txt`

echo "# Blacklisted."
for domain in $BLACKLIST
  do
    echo "address=/"${domain}"/"${DEAD}
  done

echo "# Otherwise, go to baidu public DNS."
echo "server=/#/180.76.76.76#53"
