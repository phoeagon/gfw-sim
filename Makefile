dir=$(shell pwd)

environment:	
	# pip install joblib
	# pip install requests
	-mkdir $(dir)/dist
	-mkdir $(dir)/tmp

dns_poison: environment
	cd dns_poisoning ; python update_blacklist.py -f blacklist.txt
	cd dns_poisoning ; bash generate.sh >$(dir)/tmp/blacklist.txt

collect: dns_poison
	cp -r $(dir)/misc/* $(dir)/dist
	-mkdir -p $(dir)/tmp/blacklist.txt $(dir)/dist/etc/dnsmasq.d/
	cp $(dir)/tmp/blacklist.txt $(dir)/dist/etc/dnsmasq.d/domains.conf

clean:
	-rm -r $(dir)/dist $(dir)/tmp

all: collect

