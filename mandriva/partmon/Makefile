SH=partmon
PL=partmon.pl

all: check

check:
	@for i in $(SH);do /bin/bash -n $$i || exit 1;echo $$i syntax OK;done
	@for i in $(PL);do perl -wc $$i || exit 1;done

install:
	mkdir -p $(ROOT)/usr/bin $(ROOT)/etc/rc.d/init.d
	install -D -m755 partmon $(ROOT)/etc/rc.d/init.d/partmon
	install -D -m755 partmon.pl $(ROOT)/usr/bin/partmon
	install -D -m644 partmon.sysconfig $(ROOT)/etc/sysconfig/partmon
