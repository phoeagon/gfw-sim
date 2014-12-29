#!/bin/bash
iptables -t nat -N PREVENTBYPASS

# PPTP
iptables -t nat -A PREVENTBYPASS --dport 1723 -j DROP
iptables -t nat -A PREVENTBYPASS --dport 47 -j DROP

# L2TP
iptables -t nat -A PREVENTBYPASS -p udp --dport 500 -j DROP
iptables -t nat -A PREVENTBYPASS -p udp --dport 4500 -j DROP
iptables -t nat -A PREVENTBYPASS -p udp --dport 1701 -j DROP
iptables -t nat -A PREVENTBYPASS --dport 50 -j DROP

iptables -t nat -j PREVENTBYPASS
