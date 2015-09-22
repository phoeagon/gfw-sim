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
iptables -A PREVENTBYPASS -p l2tp -j DROP

# For a more detailed description, see /etc/protocols
# GRE/ESP/IP-Encapsulate/Any-private-interior-gateway/IPIP
iptables -A PREVENTBYPASS -p gre -j DROP
iptables -A PREVENTBYPASS -p esp -j DROP
iptables -A PREVENTBYPASS -p ipencap -j DROP
iptables -A PREVENTBYPASS -p igp -j DROP
iptables -A PREVENTBYPASS -p ipip -j DROP
iptables -A PREVENTBYPASS -p encap -j DROP
iptables -A PREVENTBYPASS -p etherip -j DROP

# Drop DTLS
 iptables -A PREVENTBYPASS -p udp -m string --algo bm --to 30 --hex-string "|17 fe ff|" -j DROP


iptables -I FORWARD -j PREVENTBYPASS
