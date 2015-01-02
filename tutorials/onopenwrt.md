Installing GFW-Simulator on any OpenWRT router
======================================
phoeagon

## Easy method: Assuming on latest firmware

SSH to the router and install it with the ipk package.

      scp gfw.ipk root@192.168.1.1:/tmp
      ssh root@192.168.1.1
      opkg update
      opkg install /tmp/gfw.ipk

If you encounter any problem installing from opkg involving dependencies,
use the instruction described in *Upgrade then install from `opkg`*.

## Using our upgrade bin

This method would override your settings by issuing a `sysupgrade`.

      # On your PC.
      cd ~
      wget https://github.com/phoeagon/gfw-sim/releases/download/alpha-v0.0/conf_uploaded.bin -O 1.bin
      scp 1.bin root@192.168.1.1:/tmp/backup.bin
      ssh root@192.168.1.1
      > # on router via ssh
      > sysupgrade -n -v /tmp/backup.bin
      > # now wait till the router reboots.

You can try using `sysupgrade -v /tmp/backgup.bin` instead to try
to preserve your configurations. But this is not recommended.

## Upgrade then install from `opkg`

Upgrade your system as described [here](http://wiki.openwrt.org/doc/howto/generic.sysupgrade).

Then do as described in *Easy method: Assuming on latest firmware*.
