#################################################
# Paths etc.
#################################################

OBJECTS1 = Esimerkki1.o
OBJECTS2 = Esimerkki2.o
OBJECTS3 = Esimerkki3.o
ODIR     = Objects/
ODIRMOS  = ObjectsMOS/
OBJS     = $(addprefix $(ODIR),$(OBJECTS1))
OBJSMOS  = $(addprefix $(ODIRMOS),$(OBJECTS1))
OBJS2    = $(addprefix $(ODIR),$(OBJECTS2))
OBJS2MOS = $(addprefix $(ODIRMOS),$(OBJECTS2))
OBJS3    = $(addprefix $(ODIR),$(OBJECTS3))
OBJS3MOS = $(addprefix $(ODIRMOS),$(OBJECTS3))
IDIRS    = -IMUI:Developer/C/Include

#################################################
# Compiler stuff (VBCC)
#################################################

CC       = vc
OFLAGS   = -DVBCC -c -c99 -k -schedule -maxoptpasses=30 -O3 -size
CFLAGS   = +m68k $(OFLAGS) -sc -sd -cpu=68020
MFLAGS   = +morphos $(OFLAGS) -D__MORPHOS__ -amiga-align -sd

LFLAGS   =
LLIBS    = -lamigas -lvcs

##########################################################################

all: Esimerkki1 Esimerkki2 Esimerkki3

#################################################
# K‰‰nn‰ 1. esimerkkiohjelma
#################################################

Esimerkki1 : $(OBJS)
   $(CC) $(LFLAGS) -final -o $@ $(OBJS) $(LLIBS)

$(ODIR)Esimerkki1.o : Esimerkki1.c
   $(CC) $(CFLAGS) -o $@ Esimerkki1.c $(IDIRS)

#################################################
# K‰‰nn‰ 2. esimerkk1iohjelma
#################################################

Esimerkki2 : $(OBJS2)
   $(CC) $(LFLAGS) -final -o $@ $(OBJS2) $(LLIBS)

$(ODIR)Esimerkki2.o : Esimerkki2.c
   $(CC) $(CFLAGS) -o $@ Esimerkki2.c $(IDIRS)

#################################################
# K‰‰nn‰ 3. esimerkk1iohjelma
#################################################

Esimerkki3 : $(OBJS3)
   $(CC) $(LFLAGS) -final -o $@ $(OBJS3) $(LLIBS)

$(ODIR)Esimerkki3.o : Esimerkki3.c
   $(CC) $(CFLAGS) -o $@ Esimerkki3.c $(IDIRS)
