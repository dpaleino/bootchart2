VER=0.12.3
PKG_NAME=bootchart2
PKG_TARBALL=$(PKG_NAME)-$(VER).tar.bz2

CC ?= gcc
CFLAGS ?= -g -Wall -O0

PREFIX ?= /usr/local

COLLECTOR = \
	collector/collector.o \
	collector/output.o \
	collector/tasks.o \
	collector/tasks-netlink.o \
	collector/dump.o

all: bootchart-collector

%.o:%.c
	$(CC) $(CFLAGS) -pthread -DVERSION=\"$(VER)\" -c $^ -o $@

bootchart-collector: $(COLLECTOR)
	$(CC) -pthread -Icollector -o $@ $^

py-install-compile:
	PKG_VER=$(VER) python setup.py install --root=$(DESTDIR)/ --prefix=$(PREFIX)

install-chroot:
	install -d $(DESTDIR)/lib/bootchart/tmpfs

install-collector: all install-chroot
	install -m 755 -D bootchartd $(DESTDIR)/$(PREFIX)/sbin/bootchartd
	install -m 644 -D bootchartd.conf $(DESTDIR)/$(PREFIX)/etc/bootchartd.conf
	install -m 755 -D bootchart-collector $(DESTDIR)/$(PREFIX)/lib/bootchart/bootchart-collector

install: all py-install-compile install-collector

clean:
	-rm -f bootchart-collector bootchart-collector-dynamic collector/*.o

dist:
	COMMIT_HASH=`git show-ref -s -h | head -n 1` ; \
	git archive --prefix=$(PKG_NAME)-$(VER)/ --format=tar $$COMMIT_HASH \
		| bzip2 -f > $(PKG_TARBALL)
