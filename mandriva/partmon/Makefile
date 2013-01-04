SH=partmon partmon.sh

all: check

check:
	@for i in $(SH);do /bin/bash -n $$i || exit 1;echo $$i syntax OK;done
	@for i in $(PL);do perl -wc $$i || exit 1;done

install:
	install -m755 partmon -D $(ROOT)/etc/rc.d/init.d/partmon
	install -m755 partmon.sh -D $(ROOT)/usr/bin/partmon
	install -m644 partmon.sysconfig -D $(ROOT)/etc/sysconfig/partmon
