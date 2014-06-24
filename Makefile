ROOT=/
SUPERUSER=root
SUPERGROUP=root

VERSION := $(shell awk '/Version:/ { print $$2 }' initscripts.spec)
RELEASE := $(shell awk '/Release:/ { print $$2 }' initscripts.spec | sed 's|%{?dist}||g')
TAG=initscripts-$(VERSION)-$(RELEASE)

mandir=/usr/share/man

all:
	make -C src
	make -C po

install:
	mkdir -p $(ROOT)/etc/profile.d $(ROOT)/sbin $(ROOT)/usr/sbin
	mkdir -p $(ROOT)/etc/profile.d $(ROOT)/usr/sbin
	mkdir -p $(ROOT)$(mandir)/man{5,8}
	mkdir -p $(ROOT)/etc/rwtab.d $(ROOT)/etc/statetab.d
	mkdir -p $(ROOT)/var/lib/stateless/writable
	mkdir -p $(ROOT)/var/lib/stateless/state

	install -m644  adjtime $(ROOT)/etc
	install -m644  inittab $(ROOT)/etc
	install -m644  rwtab statetab networks $(ROOT)/etc
	install -m755  service $(ROOT)/sbin
	install -m644  lang.csh $(ROOT)/etc/profile.d/10lang.csh
	install -m644  lang.sh $(ROOT)/etc/profile.d/10lang.sh
	install -m644  256term.csh $(ROOT)/etc/profile.d/10term256.csh
	install -m644  256term.sh $(ROOT)/etc/profile.d/10term256.sh
	install -m644  debug.csh debug.sh $(ROOT)/etc/profile.d
	install -m755  sys-unconfig $(ROOT)/usr/sbin
	install -m644  service.8 sys-unconfig.8 $(ROOT)$(mandir)/man8
	mkdir -p -m 755 $(ROOT)/usr/lib/sysctl.d
	mkdir -p -m 755 $(ROOT)/etc/sysctl.d
	install -m644 sysctl.conf $(ROOT)/usr/lib/sysctl.d/00-system.conf
	if uname -m | grep -q sparc ; then \
	  install -m644 sysctl.conf.sparc $(ROOT)/usr/lib/sysctl.d/00-system.conf ; fi
	if uname -m | grep -q s390 ; then \
	  install -m644 sysctl.conf.s390 $(ROOT)/usr/lib/sysctl.d/00-system.conf ; fi
	install -m 644 sysctl.conf.README $(ROOT)/etc/sysctl.conf
	ln -s ../sysctl.conf $(ROOT)/etc/sysctl.d/99-sysctl.conf

	mkdir -p $(ROOT)/etc/X11
	install -m755 prefdm $(ROOT)/etc/X11/prefdm
	mkdir -p $(ROOT)/usr/bin
	install -m755 display-manager-failure-message $(ROOT)/usr/bin/display-manager-failure-message

	install -m755 -d $(ROOT)/etc/rc.d $(ROOT)/etc/sysconfig
	cp -af rc.d/init.d $(ROOT)/etc/rc.d/
	install -m644 sysconfig/debug sysconfig/init sysconfig/netconsole sysconfig/readonly-root $(ROOT)/etc/sysconfig/
	cp -af sysconfig/network-scripts $(ROOT)/etc/sysconfig/
	cp -af ppp NetworkManager $(ROOT)/etc
	# (cg) Are the two lines below needed these days???
	mkdir -p $(ROOT)/etc/sysconfig/console/consolefonts
	mkdir -p $(ROOT)/etc/sysconfig/console/consoletrans
	mkdir -p $(ROOT)/lib/systemd/
	cp -af systemd/* $(ROOT)/lib/systemd/
	chmod 755 $(ROOT)/lib/systemd/mandriva-*
	chmod 755 $(ROOT)/lib/systemd/mandriva-*
	mkdir -p $(ROOT)/etc/ppp/peers
	cp -af udev $(ROOT)/lib
	chmod 755 $(ROOT)/etc/rc.d/* $(ROOT)/etc/rc.d/init.d/*
	chmod 644 $(ROOT)/etc/rc.d/init.d/functions
	chmod 755 $(ROOT)/etc/ppp/peers
	chmod 755 $(ROOT)/etc/ppp/ip*
	chmod 755 $(ROOT)/etc/sysconfig/network-scripts/ifup-*
	chmod 755 $(ROOT)/etc/sysconfig/network-scripts/ifdown-*
	chmod 755 $(ROOT)/etc/sysconfig/network-scripts/init*
	chmod 755 $(ROOT)/etc/NetworkManager/dispatcher.d/00-netreport
	mkdir -p $(ROOT)/etc/sysconfig/modules
	mkdir -p $(ROOT)/etc/sysconfig/console
	if uname -m | grep -q s390 ; then \
	  install -m644 sysconfig/init.s390 $(ROOT)/etc/sysconfig/init ; \
	fi

	mv $(ROOT)/etc/sysconfig/network-scripts/ifup $(ROOT)/sbin
	mv $(ROOT)/etc/sysconfig/network-scripts/ifdown $(ROOT)/sbin
	(cd $(ROOT)/etc/sysconfig/network-scripts; \
	  ln -sf ifup-ippp ifup-isdn ; \
	  ln -sf ifdown-ippp ifdown-isdn ; \
	  ln -sf ../../../sbin/ifup . ; \
	  ln -sf ../../../sbin/ifdown . )
	make install ROOT=$(ROOT) mandir=$(mandir) -C src
	make install PREFIX=$(ROOT) -C po

	mkdir -p $(ROOT)/var/run/netreport $(ROOT)/var/log
	chown $(SUPERUSER):$(SUPERGROUP) $(ROOT)/var/run/netreport
	chmod u=rwx,g=rwx,o=rx $(ROOT)/var/run/netreport
	touch $(ROOT)/var/run/utmp
	touch $(ROOT)/var/log/wtmp
	touch $(ROOT)/var/log/btmp

	for i in 0 1 2 3 4 5 6 ; do \
		dir=$(ROOT)/etc/rc.d/rc$$i.d; \
	  	mkdir $$dir; \
		chmod u=rwx,g=rx,o=rx $$dir; \
	done
	# install translated man pages
	for j in 1 3 8 ; do \
	    for i in man/??* ; do \
		install -d $(ROOT)$(mandir)/`basename $$i`/man$$j ; \
		install -m 644 $$i/*.$$j $(ROOT)$(mandir)/`basename $$i`/man$$j ; \
	    done ; \
	done	

# Can't store symlinks in a CVS archive
	mkdir -p -m 755 $(ROOT)/lib/systemd/system/multi-user.target.wants
	mkdir -p -m 755 $(ROOT)/lib/systemd/system/graphical.target.wants
	mkdir -p -m 755 $(ROOT)/lib/systemd/system/local-fs.target.wants
	mkdir -p -m 755 $(ROOT)/lib/systemd/system/basic.target.wants
	mkdir -p -m 755 $(ROOT)/lib/systemd/system/sysinit.target.wants
	ln -s ../fedora-loadmodules.service $(ROOT)/lib/systemd/system/basic.target.wants
	ln -s ../fedora-autorelabel.service $(ROOT)/lib/systemd/system/basic.target.wants
	ln -s ../fedora-autorelabel-mark.service $(ROOT)/lib/systemd/system/basic.target.wants
	ln -s ../fedora-readonly.service $(ROOT)/lib/systemd/system/local-fs.target.wants
	ln -s ../fedora-import-state.service $(ROOT)/lib/systemd/system/local-fs.target.wants
	ln -s ../mandriva-everytime.service $(ROOT)/lib/systemd/system/basic.target.wants

	mkdir -p $(ROOT)/lib/tmpfiles.d
	install -m 644 initscripts.tmpfiles.d $(ROOT)/lib/tmpfiles.d/initscripts.conf
	install -m 644 mandriva.tmpfiles.d $(ROOT)/lib/tmpfiles.d/mandriva.conf


# These are LSB compatibility symlinks.  At some point in the future
# the actual files will be here instead of symlinks
	for i in 0 1 2 3 4 5 6 ; do \
		ln -s rc.d/rc$$i.d $(ROOT)/etc/rc$$i.d; \
	done

	mkdir -p -m 755 $(ROOT)/usr/libexec/initscripts/legacy-actions


syntax-check:
	for afile in `find . -type f -perm +111|grep -v \.csh | grep -v .git | grep -v po/ | grep -v 'gprintify.py' ` ; do \
		if ! file $$afile | grep -s ELF  >/dev/null && ! file $$afile | grep -s perl >/dev/null; then \
		    bash -n $$afile || { echo $$afile ; exit 1 ; } ; \
		fi  ;\
	done

check: syntax-check
	make check -C src
	make clean -C src

changelog:
	@rm -f ChangeLog
	git log --stat > ChangeLog

clean:
	make clean -C src
	make clean -C po
	@rm -fv *~ changenew ChangeLog.old *gz
	@find . -name "*~" -exec rm -v -f {} \;

tag:
	@git tag -a -f -m "Tag as $(TAG)" $(TAG)
	@echo "Tagged as $(TAG)"

archive: clean syntax-check tag changelog
	@git archive --format=tar --prefix=initscripts-$(VERSION)/ HEAD > initscripts-$(VERSION).tar
	@mkdir -p initscripts-$(VERSION)/
	@cp ChangeLog initscripts-$(VERSION)/
	@tar --append -f initscripts-$(VERSION).tar initscripts-$(VERSION)
	@xz -f initscripts-$(VERSION).tar
	@rm -rf initscripts-$(VERSION)
	@echo "The archive is at initscripts-$(VERSION).tar.xz"
	@sha1sum initscripts-$(VERSION).tar.xz > initscripts-$(VERSION).sha1sum
