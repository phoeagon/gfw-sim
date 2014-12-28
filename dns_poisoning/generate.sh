#!/bin/bash
DEAD="59.24.3.173"
BLACKLIST=`cat blacklist.txt`

echo "# Blacklisted."
for domain in $BLACKLIST
  do
    echo "address=/"${domain}"/"${DEAD}
  done

echo "# Otherwise, go to google public DNS."
echo "server=/#/8.8.8.8#53"
