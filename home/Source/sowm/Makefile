X11INC = /usr/local/include
X11LIB = /usr/local/lib
# includes and libs
INCS = -I${X11INC}
LIBS = -L${X11LIB} -lX11

CFLAGS += -std=c99 -Wall -Wextra -pedantic -Wold-style-declaration
CFLAGS += -Wmissing-prototypes -Wno-unused-parameter

PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
CC     ?= gcc

all: sowm

config.h:
	cp config.def.h config.h

sowm: sowm.c sowm.h config.h Makefile
	$(CC) -O3 $(CFLAGS) -o $@ $< -lX11 $(LDFLAGS) -Os ${INCS} ${LIBS}
	
install: all
	install -Dm755 sowm $(DESTDIR)$(BINDIR)/sowm

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/sowm

clean:
	rm -f sowm *.o

.PHONY: all install uninstall clean
