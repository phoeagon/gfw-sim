#!/bin/bashi
iptables -t nat -N DNSPOISONING

# Skip local
iptables -t nat -A DNSPOISONING -d 127.0.0.1 -j RETURN

# Ignore LANs ip addresses
iptables -t nat -A DNSPOISONING -d 0.0.0.0/8 -j RETURN
iptables -t nat -A DNSPOISONING -d 10.0.0.0/8 -j RETURN
iptables -t nat -A DNSPOISONING -d 127.0.0.0/8 -j RETURN
iptables -t nat -A DNSPOISONING -d 169.254.0.0/16 -j RETURN
iptables -t nat -A DNSPOISONING -d 172.16.0.0/16 -j RETURN
iptables -t nat -A DNSPOISONING -d 192.168.0.0/16 -j RETURN
iptables -t nat -A DNSPOISONING -d 224.0.0.0/4 -j RETURN
iptables -t nat -A DNSPOISONING -d 240.0.0.0/4 -j RETURN

# Redirect all DNS queries to local
iptables -t nat -A DNSPOISONING -p udp --destination-port 53 -j REDIRECT --to-ports 53

# Apply
iptables -t nat -A PREROUTING -j DNSPOISONING
