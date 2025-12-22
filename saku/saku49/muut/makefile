# "osa4" Makefile

CC = gcc
CFLAGS = -O2 `sdl-config --cflags` -Wall -I../../include
STRIP = strip
LIBS = -laboxstubs -labox `sdl-config --libs` -lSDL_image -ltinyglu

OSA4OBJS = osa4.o



osa4: $(OSA4OBJS)
	$(CC) $(CFLAGS) -o $@.db $(OSA4OBJS) $(LIBS)
	$(STRIP) --strip-unneeded --remove-section=.comment $@.db -o $@
	chmod u+x $@

clean:
	rm -f *.o osa4 *.db

