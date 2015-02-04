#!/bin/sh
DEAD_IPS=`wget -O - 'https://gist.github.com/felixonmars/7ce1dcd193c65937e670/raw/f75bce4a0f9420f08cedad26477f98b5fbc0ec2e/dns_pollution_iplist.txt'`
wget -O /tmp/bl.txt https://raw.githubusercontent.com/Leask/BRICKS/master/gfw.bricks
BLACKLIST=`cat /tmp/bl.txt blacklist.txt | sort | uniq`

echo "# Blacklisted."
for domain in $BLACKLIST
  do
    DEAD=`echo $DEAD_IPS | tr ' ' '\n' | sort -R | head -1`
    echo "address=/"${domain}"/"${DEAD}
  done



echo "# Otherwise, go to baidu public DNS."
echo "server=/#/180.76.76.76#53"
