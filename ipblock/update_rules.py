import socket
import requests
import random
import re
import ipaddr
from ipwhois import IPWhois
from joblib import Parallel, delayed

def is_ip(addr):
    try:
        socket.inet_aton(addr)
        return True
    except socket.error:
        return False

def resolve_addr(addr):
    try:
        addr = addr.strip()
        if not is_ip(addr):
            ip = socket.gethostbyname(addr)
            if not ip:
                ip = socket.gethostbyname('www.' + addr)                
        else:
            ip = addr
        ip = ip[:ip.rfind('.')] + '.0/24'
        return ip
    except:
        return None

def generate_from_domain(filename='resource/domains.txt', thread_num=20):
    f = open(filename, 'r')
    _parallel = Parallel(n_jobs=thread_num, backend="threading")
    resolved_addr = _parallel(delayed(resolve_addr)(addr) for addr in f.readlines())
    return [addr for addr in resolved_addr if addr]

def generate_from_subnets(filename='resource/ips.txt'):
    return open(filename, 'r').readlines()

def generate_google_ips_from_online(url='https://raw.githubusercontent.com/justjavac/Google-IPs/master/README.md'):
    return generate_ip_list_from_url(url)

def generate_from_smarthost(url='https://smarthosts.googlecode.com/svn/trunk/hosts'):
    return generate_ip_list_from_url(url)
    
def generate_ip_list_from_url(url):
    r = requests.get(url)
    if r.status_code != 200:
        # Fail
        return []
    content = r.text
    matches = re.findall('[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+', content)
    matches = list({ip[:ip.rfind('.')] + '.0/24' for ip in matches})
    return matches

def generate_iptables_from_subnets(subnets, actions=None):
    if not actions:
        actions = ['-p tcp -j REJECT --reject-with tcp-reset', '-j DROP']
    subnets = list({subnet.strip() for subnet in subnets if subnet})
    cont = ['#!/bin/sh', 'iptables -N IPBLOCK']
    for subnet in subnets:
        rule = ('iptables -A IPBLOCK -d ' + subnet + ' '
                + random.choice(actions))
        cont.append(rule)
    cont.extend([#'iptables -I INPUT -j IPBLOCK',
                #'iptables -I OUTPUT -j IPBLOCK',
                'iptables -I FORWARD -j IPBLOCK'])
    return '\n'.join(cont)

whois_pool = []
def run_whois(addr):
    is_in = lambda addr, pool: reduce(lambda x,y: x or y,
                    [net.Contains(addr) for net in pool],
                    False)
    sample = addr[:addr.rfind('.')] + '.1/32'
    ip = ipaddr.IPv4Network(sample)
    if not is_in(ip, whois_pool):
        try:
            data = IPWhois(addr[:addr.rfind('.')] + '.1').lookup(get_referral=True)
            cidr = data['nets'][0]['cidr']
            whois_pool.append(ipaddr.IPv4Network(cidr))
            return cidr
        except:
            return addr
    return None

def resolve_whois_subnet(subnet):
    _parallel = Parallel(n_jobs=20, backend="threading")
    result = _parallel(delayed(run_whois)(addr) for addr in subnet)
    return [x for x in result if x]
    

def generate_iptables():
    resolved_subnets = resolve_whois_subnet(
                generate_google_ips_from_online() +
                generate_from_subnets() + generate_from_domain('resource/heavy_domains.txt'));
    subnets = ( resolved_subnets + generate_from_smarthost() +
               generate_from_domain() )
    return generate_iptables_from_subnets(subnets)
    

if __name__ == '__main__':
    print generate_iptables()
