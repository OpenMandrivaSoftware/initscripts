INSTALL= /usr/bin/install -c
INSTALL_PROGRAM= ${INSTALL}
INSTALL_DATA= ${INSTALL} -m 644
INSTALLNLSDIR=/usr/share/locale
RPMROOT=/mnt/BIG/dis/cooker/i586/media

MSGMERGE = msgmerge

NLSPACKAGE = initscripts

CATALOGS = $(shell ls *.po)
FMTCATALOGS = $(patsubst %.po,%.mo,$(CATALOGS))

all: $(FMTCATALOGS)

POTFILES:
	rm -f etc/init.d/* etc/rc.d/init.d/*
	for i in `find $(RPMROOT)/*/release -name '*.rpm' \! -path '$(RPMROOT)/debug*'`; do \
		rpm2cpio $$i | cpio --quiet -id './etc/rc.d/init.d/*' './etc/init.d/*'; \
	done
	mv etc/init.d/* etc/rc.d/init.d/

pot $(NLSPACKAGE).pot: POTFILES
	rm -rf etc/sysconfig etc/rc.d/rc*
	mkdir -p etc/rc.d etc/sysconfig/network-scripts
	cp ../../sysconfig/network-scripts/* etc/sysconfig/network-scripts/
	cp ../../rc.d/rc*  etc/rc.d/
	../gprintify.py etc/rc.d/rc* etc/sysconfig/network-scripts/* etc/rc.d/init.d/*
	./xgettext_sh.py `find etc -type f` > $(NLSPACKAGE).po
	sed -i -e '/^#:/s|etc/|/etc/|g' -e "s/=CHARSET/=utf-8/" $(NLSPACKAGE).po
	msgattrib -F $(NLSPACKAGE).po -o $(NLSPACKAGE).po
	msgcat EXTRA_STRINGS $(NLSPACKAGE).po --use-first > $(NLSPACKAGE).tmp.po
	if cmp -s $(NLSPACKAGE).tmp.po $(NLSPACKAGE).pot; then \
	    rm -f $(NLSPACKAGE).tmp.po; \
	else \
	    mv $(NLSPACKAGE).tmp.po $(NLSPACKAGE).pot; \
	fi
	rm -rf $(NLSPACKAGE).po etc/sysconfig etc/rc.d/rc*

update-po: $(NLSPACKAGE).pot refresh-po

refresh-po:
	catalogs='$(CATALOGS)'; \
	for cat in $$catalogs; do \
		lang=`basename $$cat .po`; \
		if $(MSGMERGE) $$lang.po $(NLSPACKAGE).pot > $$lang.pot ; then \
			mv -f $$lang.pot $$lang.po ; \
			echo "$(MSGMERGE) of $$lang succeeded" ; \
		else \
			echo "$(MSGMERGE) of $$lang failed" ; \
			rm -f $$lang.pot ; \
		fi \
	done

clean:
	rm -f *mo *.pyc

distclean: clean
	rm -f .depend Makefile

depend:

install:	all
	mkdir -p $(PREFIX)/$(INSTALLNLSDIR)
	for n in $(CATALOGS); do \
	    l=`basename $$n .po`; \
	    mo=$$l.mo; \
	    $(INSTALL) -m 755 -d $(PREFIX)/$(INSTALLNLSDIR)/$$l; \
	    $(INSTALL) -m 755 -d $(PREFIX)/$(INSTALLNLSDIR)/$$l/LC_MESSAGES; \
	    $(INSTALL) -m 644 $$mo \
		$(PREFIX)/$(INSTALLNLSDIR)/$$l/LC_MESSAGES/$(NLSPACKAGE).mo; \
	done

%.mo: %.po
	sed 's/$[a-zA-Z0-9_{}]*/%s/g' < $< | msgfmt -o $@ -
