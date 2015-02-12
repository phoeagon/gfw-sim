from argparse import ArgumentParser
from generate_from_subnets import get_socks_keys

def parse_args():
    parser = ArgumentParser()
    parser.add_argument('-f', '--file', dest='input', required=True,
                        help='Path of blacklisted keywords')
    parser.add_argument('--sid', dest='sid',
                        help='First sid to use')
    return parser.parse_args()


def generate_snort_rules(blacklist, start_sid=1000000):
    for word in blacklist:
        start_sid += 1
        print "reject tcp any any -> any any (content: \"%s\";sid: %d;)" % (word.strip(), start_sid)


def decorate_socks_keys():
    return map(lambda x:'|'+x+'|',
               [" ".join(s[i:i+2] for i in range(0, len(s), 2))
                                  for s in get_socks_keys()])
    
def main():
    args = parse_args()
    blacklist = open(args.input, 'r').readlines() + decorate_socks_keys()
    start_sid = int(args.sid or 1000000)
    generate_snort_rules(blacklist, start_sid)

if __name__ == '__main__':
    main()
