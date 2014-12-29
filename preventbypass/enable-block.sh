#!/bin/sh
iptables -N PREVENTBYPASS

# PPTP
iptables -A PREVENTBYPASS --dport 1723 -j DROP
iptables -A PREVENTBYPASS --dport 47 -j DROP

# L2TP
iptables -A PREVENTBYPASS -p udp --dport 500 -j DROP
iptables -A PREVENTBYPASS -p udp --dport 4500 -j DROP
iptables -A PREVENTBYPASS -p udp --dport 1701 -j DROP
iptables -A PREVENTBYPASS --dport 50 -j DROP

iptables -I FORWARD -j PREVENTBYPASS
