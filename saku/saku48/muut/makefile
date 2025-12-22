CC = gcc
CFLAGS = -O2 -Wall -noixemul -I../../include
STRIP = strip
LIBS = -laboxstubs -labox -ltinygl -noixemul

OSA3OBJS = osa3.o

all: osa3


osa3: $(OSA3OBJS)
	$(CC) $(CFLAGS) -o $@.db $(OSA3OBJS) $(LIBS)
	$(STRIP) --strip-unneeded --remove-section=.comment $@.db -o $@
	chmod u+x $@

clean:
	rm -f *.o osa3 *.db

