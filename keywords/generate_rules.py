import requests

def _get_keywords_from_google(url='https://gist.githubusercontent.com/zythum/2848881/raw/4bae5bd21da3ed44b8a2cc9d2c1d6cd4c70dc74c/gistfile1.txt'):
    r = requests.get(url)
    if r.status_code != 200:
        return []
    r.encoding = 'utf-8'
    content = r.text.replace('|', '\n').replace('"', '').replace("'", '')
    return content.splitlines(False)

def _get_domain_keywords(filename='resource/domains.txt'):
    try:
        return open(filename, 'r').readlines()
    except:
        return []


def get_keywords():
    return _get_domain_keywords() + _get_keywords_from_google()

def generate_iptables(keywords, action='-j REJECT --reject-with tcp-reset'):
    cont = ['#!/bin/bash', 'iptables -t nat -N KEYWORDS']
    cont += [('iptables -t nat -A KEYWORDS -m string --algo bm --string "'
                + kw.strip() +  '" ' + action) for kw in keywords]
    cont.append('iptables -t nat -j KEYWORDS')
    return '\n'.join(cont)

def main():
    print generate_iptables(get_keywords())

if __name__ == '__main__':
    main()
