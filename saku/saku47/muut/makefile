CC = gcc
CFLAGS = -O2 -Wall -noixemul -I../../include
STRIP = strip
LIBS = -laboxstubs -labox -ltinygl -noixemul

OSA1OBJS = osa1.o
OSA2OBJS = osa2.o

all: osa1 osa2

osa1: $(OSA1OBJS)
	$(CC) $(CFLAGS) -o $@.db $(OSA1OBJS) $(LIBS)
	$(STRIP) --strip-unneeded --remove-section=.comment $@.db -o $@
	chmod u+x $@

osa2: $(OSA2OBJS)
	$(CC) $(CFLAGS) -o $@.db $(OSA2OBJS) $(LIBS)
	$(STRIP) --strip-unneeded --remove-section=.comment $@.db -o $@
	chmod u+x $@

clean:
	rm -f *.o osa1 osa2 *.db

