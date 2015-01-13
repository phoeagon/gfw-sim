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

collect: dns_poison ip_block preventbypass keywords updater
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

updater: environment
	cp updater/updater.sh $(dir)/dist/usr/bin/gfw.updater.sh

ipk: 
	cp -r ipk tmp/
	cp -r dist/* tmp/ipk/
	tmp/ipk/make_ipk.sh $(dir)/releases/gfw.ipk ./tmp/ipk

ipk-snort:
	cp -r ipk-snort tmp/
	cp -r misc-snort/* tmp/ipk-snort
	cp keywords/local.gfw.rules ./tmp/ipk-snort/etc/snort/rules/
	tmp/ipk-snort/make_ipk.sh $(dir)/releases/gfw-snort.ipk ./tmp/ipk-snort

deb:
	-mkdir dist_pc
	chmod 755 dist_pc
	# Make a copy
	tar cf dist_pc.tar dist_pc
	-rm -rf dist_pc/usr dist_pc/etc
	cp -r dist/* dist_pc
	# Add copyright file
	cp LICENSE dist_pc/DEBIAN/copyright
	# Fix init.d script: overwrite
	mv dist_pc/DEBIAN/etc.init.d.gfw dist_pc/etc/init.d/gfw
	# Put changelog/copyright file
	gzip --best dist_pc/DEBIAN/changelog dist_pc/DEBIAN/changelog.Debian
	-mkdir -p dist_pc/usr/share/doc/gfwsim/
	mv dist_pc/DEBIAN/copyright dist_pc/usr/share/doc/gfwsim/
	mv dist_pc/DEBIAN/*.gz dist_pc/usr/share/doc/gfwsim/
	# Fix up rules
	sed -i -e "s|/etc/init.d/firewall restart|iptables -F|g" dist_pc/etc/init.d/gfw
	sed -i -e "s|FORWARD|OUTPUT|g" dist_pc/usr/bin/*.sh
	sed -i -e "s|PREROUTING|OUTPUT|g" dist_pc/usr/bin/dns.sh
	sed -i -e "s|127.0.0.1|180.76.76.76|g" dist_pc/usr/bin/dns.sh
	# Generate MD5sum & Configure file list
	find dist_pc/etc -type f | sed -e 's|dist_pc/|/|g' >dist_pc/DEBIAN/conffiles
	md5sum `find dist_pc/etc dist_pc/usr -type f ` | sed -e 's|dist_pc/||g' >dist_pc/DEBIAN/md5sums
	# Fix permission
	chown -R root:root dist_pc/*
	# Actual build
	dpkg-deb --build dist_pc
	chmod 777 dist_pc.deb
	mv dist_pc.deb ./releases/
	-rm -rf dist_pc
	# Decompress from backup tarball
	tar xf dist_pc.tar
	
	

all: collect
	make -B ipk

