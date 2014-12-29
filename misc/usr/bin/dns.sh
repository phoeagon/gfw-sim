#!/bin/sh
iptables -t nat -N DNSPOISONING

# Skip local
iptables -t nat -A DNSPOISONING -d 127.0.0.1 -j RETURN

# Redirect all DNS queries to local
iptables -t nat -A DNSPOISONING -p udp --destination-port 53 -j REDIRECT --to-ports 53

# Apply
iptables -t nat -A PREROUTING -j DNSPOISONING
