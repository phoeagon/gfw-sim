#!/bin/bash
iptables -t nat -N IPBLOCK

iptables -A IPBLOCK -p tcp -d xxxx --dport 1234 -j REJECT --reject-with tcp-reset
