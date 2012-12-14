SH=vpn-start vpn-stop vpn-ifup vpn-ifdown
PL=partmon.pl

all: check

check:
	@for i in $(SH);do /bin/bash -n $$i || exit 1;echo $$i syntax OK;done

install:
	mkdir -p $(ROOT)/etc/sysconfig/network-scripts/vpn.d/{openvpn,pptp,vpnc}
	install -m755 vpn-start $(ROOT)/usr/sbin/
	install -m755 vpn-stop $(ROOT)/usr/sbin/	
	install -m755 vpn-ifup $(ROOT)/etc/sysconfig/network-scripts/ifup.d/vpn
	install -m755 vpn-ifdown $(ROOT)/etc/sysconfig/network-scripts/ifdown.d/vpn
