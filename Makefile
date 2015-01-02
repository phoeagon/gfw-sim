dir=$(shell pwd)

environment:	
	# pip install joblib
	# pip install requests
	-mkdir $(dir)/dist
	-mkdir $(dir)/tmp

dns_poison: environment
	cd dns_poisoning ; python update_blacklist.py -f blacklist.txt
	cd dns_poisoning ; sh generate.sh >$(dir)/tmp/blacklist.txt

ip_block: environment
	cd ipblock ; python update_rules.py >$(dir)/tmp/ipblock.sh

keywords: environment
	cd keywords ; export PYTHONIOENCODING="UTF-8"; python generate_rules.py >$(dir)/tmp/keywords.sh

collect: dns_poison ip_block preventbypass keywords
	cp -r $(dir)/misc/* $(dir)/dist

	-mkdir -p $(dir)/dist/etc/dnsmasq.d/
	cp $(dir)/tmp/blacklist.txt $(dir)/dist/etc/dnsmasq.d/domains.conf
	
	-mkdir -p $(dir)/dist/usr/bin/
	cp $(dir)/tmp/ipblock.sh $(dir)/dist/usr/bin/ipblock.sh
	cp $(dir)/tmp/keywords.sh $(dir)/dist/usr/bin/keywords.sh

	cp $(dir)/preventbypass/enable-block.sh $(dir)/dist/usr/bin/preventbypass.sh
	chmod +x $(dir)/dist/usr/bin/*
	chmod +x $(dir)/dist/etc/init.d/*

preventbypass: environment
	
clean:
	-rm -r $(dir)/dist $(dir)/tmp

update: collect
	tar zcvf update.tgz -C dist `ls dist`
	-mkdir releases
	mv update.tgz releases/
	md5sum releases/update.tgz | awk '{print $1;}' > ./tmp/md5sum
	cat releases/digest | tail --lines=+2 >> ./tmp/md5sum
	mv ./tmp/md5sum releases/digest

ipk:
	cp -r ipk tmp/
	cp -r dist/* tmp/ipk/
	tmp/ipk/make_ipk.sh $(dir)/releases/gfw.ipk ./tmp/ipk

all: collect
	make -B ipk

