from argparse import ArgumentParser

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


def main():
    args = parse_args()
    blacklist = open(args.input, 'r').readlines()
    start_sid = int(args.sid) or 1000000
    generate_snort_rules(blacklist, start_sid)

if __name__ == '__main__':
    main()
