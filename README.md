GFW Simulator
=======================
phoeagon

A [GFW](http://en.wikipedia.org/wiki/Golden_Shield_Project)
simulator to work on routers, based on [OpenWRT](http://openwrt.org).
This is a mock implementation of GFW on OpenWRT routers.

A non-technical description [here](http://gfwrouter.info).

## Getting Started

Assume you have a router that is already with OpenWRT installed. (14.07
Barrier Breaker recommended).

Grab the `ipk` files from 
[`./releases`](https://github.com/phoeagon/gfw-sim/tree/release/releases)
under *release* branch. (`gfw.ipk` and optionally `gfw-snort.ipk`.)

	cd /tmp
	wget "https://github.com/phoeagon/gfw-sim/raw/release/releases/gfw.ipk"
	wget "https://github.com/phoeagon/gfw-sim/raw/release/releases/gfw-snort.ipk"
	scp gfw*.ipk root@[router_ip]:/tmp
	ssh root@[router_ip]
	> # On your router
	> opkg update
	> opkg install /tmp/gfw.ipk
	# This installs the main component
	# If you would like to install the keyword censoring system with
	# Snorb, go on with:
	> opkg install /tmp/gfw-snorb.ipk
	# No matter whether you install `gfw-snorb.ipk`, do a
	> reboot
	# to finish up.


## Goal

The router simulates the end-user experience as if within GFW. It aims at
providing a *seemless, immersive* Internet experience with Chinese
characteristics.

The router does not replicate the internal mechanism of GFW, and may use
different techniques to provide similar user experience. For instance,
in the early days GFW did not drop packets but instead send RST packets to
force hang up a connection. It might also send bogus DNS responses but doesn't
intercept the original one. This implementation does not aim at reproducing
such mechanisms.

## Installation

Currently the project is not for production use, yet.

### Prebuilt images

Currently only prebuilt images for D-Link DIR-505 is available. The file
may be found in our release tab. It's based on the trunk version of 
OpenWRT (as of 2014/12/30).

To install the prebuilt image, use any router with OpenWRT already installed.
(The following procedure erases your configurations on the router, so always
backup first!)

		(pc)> scp prebuilt.bin root@[router_ip]:/tmp/
		(pc)> ssh root@[router_ip]
			$ sysupgrade -n -v /tmp/prebuilt.bin
			# -n for not preserving your current configurations. You may
			# go without it if you know what you are doing.

The prebuilt images has password `gfw-protected` for its Wifi and SSH login.
And works as a wireless router, sharing Internet access from `eth1`, from which
it gets a dynamic IP from DHCP, to provide WiFi Internet access to `wlan0`, under
the AP name `GFWed`.

### Installing with OpenWRT's `opkg`

Grab the `gfw*.ipk` files from `releases` folder.

	cd /tmp
	wget "https://github.com/phoeagon/gfw-sim/raw/release/releases/gfw.ipk"
	wget "https://github.com/phoeagon/gfw-sim/raw/release/releases/gfw-snort.ipk"
	scp gfw*.ipk root@[router_ip]:/tmp
	ssh root@[router_ip]
	> # On your router
	> opkg update
	> opkg install /tmp/gfw*.ipk
	> reboot		

### Installing with source files

It's only tested on an Ubuntu trusty.

1. Install python (version 2), and relevant libraries (`joblib`, `requests`).

		# Assuming python2 is already installed (as by default).
		sudo apt-get install pip
		sudo pip install joblib
		sudo pip install requests

2. Do a `make` at the root of the source file. You need an uncensored network
connection for this.

3. Get the compiled rule files under `/dist`.

4. Transfer the files to OpenWRT:

		scp -r dist/* root@[ip_of_router]:/

5. At the router, you should install `iptables-mod-filter`.

		opkg update
		opkg install iptables-mod-filter


### Installing with prebuilt rule files

		(pc) > ssh root@[router_ip]
			 $ opkg update
			 $ opkg install wget tar iptables-mod-filter dnsmasq
			 $ wget -O /tmp/gfw.tgz "https://github.com/phoeagon/gfw-sim/raw/release/releases/update.tgz"
			 $ cd /
			 $ tar xf /tmp/gfw.tgz
			 $ /etc/init.d/gfw enable
			 $ /etc/init.d/gfw start

## Design and Implementation

The implementation consists of four modules:

+ DNS Poisoning
+ IP Blocking
+ Keywords Censoring
+ Prevention of Bypassing

### DNS Poisoning

The router sets up a DNS server with `dnsmasq` listening for requests from port
53. This DNS daemon has a internal list of domains that are hardwired to return
a static IP address, preventing the correct IP address being returned.

For those not on the list, the daemon makes requests to *Baidu Public DNS Server* and returns the response as is.

With `iptables`, all UDP traffic to any IP address through port 53 is redirected to this server.

### IP Blocking

The router has a list of blacklisted subnets. All traffic to those are rejected
by `iptables`.

The generation tool gathers such subnets by looking up several online resources and making DNS queries to a list of blacklisted domains.

### Keyword Censoring

Reluctant to deploy a transparent proxy, currently it is implemented using
the string matcher of `iptables`, which requires `iptables-mod-filter` on
OpenWRT.

For some reason, currently it only works for UDP but not TCP traffic. We
don't know why.

### Prevention of Bypassing

The implementation does not intend to simulate the behaviour on this aspect
much. Theoretically, if string matching does work, unencrypted HTTP proxies to
blacklisted domains should be rejected by KEYWORDS module.

This implementation does not simulate the behaviour of GFW against famous
ways to bypass censorship, including but not limited to:

+ SSH Tunneling
+ Tor
+ OpenVPN
+ ...

It does block several ports to prevent PPTP & L2TP connections though.

## Notes

Other alternatives to imitate a GFW:

+ [DumbHosts](https://github.com/phoeagon/dumbhosts)
+ [GFW-PAC](https://github.com/phoeagon/gfw-pac)

## F.A.Q.

N/A
