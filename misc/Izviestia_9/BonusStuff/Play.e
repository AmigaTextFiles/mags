/*                             */
/* Najmniejszy Player Ôwiata   */
/* by Corn'ck of Art-B         */
/* zgodne z OS1.3 i Amiga E2.x */
/*                             */

MODULE 'intuition/intuition'

/* staîe */

ENUM NOBLAD=0,NO_STLIB,BLAD2,NO_NAME,NO_MEM,NO_FILE
CONST BUFSIZE=GADGETSIZE*3

/* zmienne */

DEF streplaybase
DEF buf[BUFSIZE]:ARRAY

PROC main() HANDLE

	DEF name,l,wyn,wptr,flags,next,w,idcmp
	DEF gad:PTR TO gadget

   /* pobranie nazwy z konsoli */

   name:=arg
   l:=StrLen(name)
	IF l<1 THEN Raise(NO_NAME)

	/* otwarcie biblioteki */

	IF (streplaybase:=OpenLibrary('streplay.library',0))=NIL THEN Raise(NO_STLIB)

	/* îadowanie (bez skojarzeï!!!) */

	wyn:=load(name)
	IF wyn=-2 THEN Raise(NO_MEM)
	IF wyn=-1 THEN Raise(NO_FILE)

	/* odgrywanie */

	play()

	/* definicja okna i gadûetów */
	/* brzydkie, ale zgodne z OS3.0 */

   next:=Gadget(buf,NIL,1,0,40,22,110,'Îaduj')
   next:=Gadget(next,buf,2,0,40,37,110,'Odtwarzaj')
   next:=Gadget(next,buf,3,0,40,52,110,'Stop')

	flags:=WFLG_DRAGBAR OR WFLG_DEPTHGADGET OR WFLG_CLOSEGADGET OR WFLG_ACTIVATE
	idcmp:=IDCMP_CLOSEWINDOW+IDCMP_GADGETUP
	IF (wptr:=OpenW(0,10,300,90,idcmp,flags,'Tracker Module Player',NIL,1,buf))=NIL THEN Raise(NO_MEM)

	TextF(8,20,'Odgrywam: \s[30]\r',name)

	WHILE WaitIMessage(wptr)<>IDCMP_CLOSEWINDOW
		gad:=MsgIaddr()
		w:=gad.userdata
		IF w=2
			play()
		ELSEIF w=3
			stop()
		ENDIF
	ENDWHILE

   CloseW(wptr)

   /*   UnLoadModule()   */

   MOVE.L  streplaybase,A6
   JSR     -36(A6)
   Raise(NOBLAD)

EXCEPT

   /* Zamkniëcie biblioteki i obsîuga bîëdów */

   IF streplaybase THEN CloseLibrary(streplaybase)
	IF exception
		SELECT exception
			CASE NO_STLIB
				WriteF('Nie masz STReplay.library v2.0+!\n')
			CASE NO_NAME
				WriteF('\e[1mTracker Module Player\n\e[0m\e[2mPD by Tomasz Korolczuk\e[0m\n')
				WriteF('\e[3mUsage: \e[0mname modulename\n')
			CASE NO_MEM
				WriteF('Maîo pamiëci!!!\n')
			CASE NO_FILE
				WriteF('Nie znalazîem tego pliku!\n')
		DEFAULT
			WriteF('Bîâd nr \d!\n',exception)
		ENDSELECT
	ENDIF
	CleanUp(5)
ENDPROC

PROC load(name)

   DEF wyn

   MOVE.L name,A0
   MOVE.L streplaybase,A6
   JSR    -30(A6)
   MOVE.L D0,wyn

ENDPROC wyn
PROC play()

   MOVE.L streplaybase,A6
   JSR    -48(A6)

ENDPROC
PROC stop()

   MOVE.L streplaybase,A6
   JSR    -54(A6)

ENDPROC
