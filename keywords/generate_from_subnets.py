#!/usr/bin/env python
import ipaddr
import binascii
import math
import sys


def get_subnets(filename='resource/subnets.txt'):
    f = open(filename, 'r')
    subnets = f.readlines()
    f.close()
    return subnets

def generate_from_subnets(subnets):
    key_set = set()
    for subnet in subnets:
        subnet = subnet.strip()
        sub = ipaddr.IPv4Network(subnet)
        length = int(math.ceil(sub.prefixlen/8.0))
        new_set = {binascii.hexlify(a.packed[0:length])
                   for a in sub.iter_subnets(new_prefix=length*8)}
        key_set = key_set.union(new_set)
    return key_set


def get_iptables_rules(filename='resource/subnets.txt'):
    return generate_iptables(generate_from_subnets(get_subnets(filename)))
    
    
def main():
    if '-h' in sys.argv or '--help' in sys.argv:
        usage()
    else:
        if len(sys.argv)>1:
            subnets = get_subnets(sys.argv[1])
        else:
            subnets = get_subnets()
        print generate_iptables(generate_from_subnets(subnets))

def usage():
    print 'Generate iptables keywords.'
    print 'Usage: ./generate_from_subnets.py [subnet_file]'

'''   The SOCKS request is formed as follows:

        +----+-----+-------+------+----------+----------+
        |VER | CMD |  RSV  | ATYP | DST.ADDR | DST.PORT |
        +----+-----+-------+------+----------+----------+
        | 1  |  1  | X'00' |  1   | Variable |    2     |
        +----+-----+-------+------+----------+----------+

     Where:

          o  VER    protocol version: X'05'
          o  CMD
             o  CONNECT X'01'
             o  BIND X'02'
             o  UDP ASSOCIATE X'03'
          o  RSV    RESERVED
          o  ATYP   address type of following address
             o  IP V4 address: X'01'
             o  DOMAINNAME: X'03'
             o  IP V6 address: X'04'
          o  DST.ADDR       desired destination address
          o  DST.PORT desired destination port in network octet
             order
'''
def generate_socks_keys(keywords):
    return map(str.strip,
                  reduce(list.__add__,
                         map(lambda x: ['04010001'+x, '05010001'+x], list(keywords))))


def generate_iptables(keywords, action='-p tcp --to 256 -j REJECT --reject-with tcp-reset'):
    # Block CONNECT-IPV4-, both SOCKS4 & SOCKS5
    cont = ['# This blocks SOCKS connections by IP Range.']
    cont += [('iptables -A IPBLOCK -m string --algo bm --hex-string "|'
                + kw +  '|" ' + action) for kw in generate_socks_keys(keywords)]
    return '\n'.join(cont)


def get_socks_keys(filename='resource/subnets.txt'):
    return generate_socks_keys(generate_from_subnets(get_subnets()))

    
if __name__ == '__main__':
    main()
