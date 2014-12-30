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

def generate_iptables(keywords, action='-p tcp -j REJECT --reject-with tcp-reset'):
    cont = ['#!/bin/sh', 'iptables -N KEYWORDS']
    cont += [('iptables -A KEYWORDS -m string --algo bm --string "'
                + kw.strip() +  '" ' + action) for kw in keywords]
    cont.extend([#'iptables -I INPUT -j KEYWORDS',
                #'iptables -I OUTPUT -j KEYWORDS',
                'iptables -I FORWARD -j KEYWORDS'])
    return '\n'.join(cont)

def main():
    print generate_iptables(get_keywords())

if __name__ == '__main__':
    main()
