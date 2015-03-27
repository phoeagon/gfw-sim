#!/bin/sh

# Always end previous instances first
if [ -f /tmp/hijack.pid ]; then
    kill -9 /tmp/hijack.pid
    killall netcat
    rm /tmp/hijack.pid
fi
if [ $1 = 'stop' ];then
    exit
fi

# Assume we are starting
echo $$ > /tmp/hijack.pid
while [ 1 -eq 1 ]; do
    netcat -l 80 < /etc/hijact.txt
done
