;	  _______  ___                    ___        _______
;	 /°-     \/. /    _____   ____   / ./       /°-     \
;	 \   \___//  \___/°    \_/°   \_/   \___    \   \___/
;	_/\__    \      ~\_  /\  \  /\ ~\      °\_ _/\__    \
;	\\       /   /\   /  \/. /  \/   \ //\   / \\       /
;	 \______/\__/  \_/\_____/\____/\_/_/  \_/ o \______/ Issue 1

;Mandlebrot fractal routine
;I'm not sure who wrote this I'm afraid, someone in Epsilon perhaps ?, well
;all I've done is make it A1200 compatable and set it up my way...
;( Also, I don't have a clue how to do fractal routines ! And the lack of
;comments in this source dosen't really help me much either ! )
;Squize	17/12/94

	opt c-				;Always set this !

	Section	Fractal,Code		;Always put the code in public mem,
					;so people with Fast Ram get the
					;benefit

;*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*

	include	SHOAH.s:SHOAH_Libs/Macros.lib
					;I've made some nice macros to
					;make life that little bit easier

;*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*

Start:
	bsr.s	TakeSystem		;Kill the OS
	tst	d0			;Did we have an error ?
	bne.s	Error			;Yes, so quit

	bsr	Init			;Run our little example

	bsr	RestoreSystem		;Finished, so restore the OS

	moveq.l	#0,d0			;Keep Mr.CLI happy
Error:
	rts

;*+*+*+*+*+*+*+*+*+*+*+- Library Routines -+*+*+*+*+*+*+*+*+*+*+*+*+*+*+
	
	include	SHOAH.s:SHOAH_Libs/Startup.lib

;*+*+*+*+*+*+*+*+*+*+*+- Start up Routines -+*+*+*+*+*+*+*+*+*+*+*+*+*+*
Init:
	Copper_Set	Copperlist		;This is my macro for turning
						;on the copperlist

	bsr	InstallBmap

	move	#%1000001111000000,$96(a5)	;DMA:Blit/Bitpl/Copper

	bsr.s	Main				;Now run the main loop

	rts					;All done, so go back to
						;"RestoreSystem"

;*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
;*+*+*+*+*+*+*+*+*+*+*+- The Main Loop -+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
;*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
MAIN:

;*+*+*+	Plot that nice pattern...
	bsr	Plot_Mandlebrot

;*+*+*+	Check for quit

	Mouse_button	Main		;Another macro, if the left mouse
					;button is not pressed then it'll
					;loop to main
	rts				;LMB pressed, so return to "Init"

;*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
;*+*+*+*+*+*+*+*+*+*+*+- Subroutines -+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
;*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*

;*+*+*+*+*+*+*+*+*+*+*+- Set up the plane pointers -+*+*+*+*+*+*+*+*+*+*
InstallBmap:
	lea	bmapptrs,a0		;This just sets up 5 bitplanes ( 32
	move.l	#Bmap,d0		;colours ). It's not the fastest way
	move.w	d0,6(a0)		;to do this, but because we don't
	swap	d0			;bother double buffering the screen
	move.w	d0,2(a0)		;it dosen't really make much
	swap	d0			;difference
	
	add.l	#8000,d0
	move.w	d0,14(a0)
	swap	d0
	move.w	d0,10(a0)
	swap	d0
	
	add.l	#8000,d0
	move.w	d0,22(a0)
	swap	d0
	move.w	d0,18(a0)
	swap	d0
	
	add.l	#8000,d0
	move.w	d0,30(a0)
	swap	d0
	move.w	d0,26(a0)
	swap	d0

	add.l	#8000,d0
	move.w	d0,38(a0)
	swap	d0
	move.w	d0,34(a0)

	rts

;*+*+*+*+*+*+*+*+*+*+*+- Do that magic fractal stuff -+*+*+*+*+*+*+*+*+*
Plot_Mandlebrot:
	lea	Bmap,a4
	moveq	#0,d4
	move.l	#-$8000000*2,a1
	move.l	#100,a2
	move.l	#8000,a3

	lea	Values,a6			;Point to the patterns
	move.l	(a6)+,d1			;Set the x/y values
	move.l	(a6),d2

	move.l	#319,d5
	moveq	#$f,d6
	moveq	#7,d7

yloop:
	move.l	d5,d3
	move.l	#$8000000*2,a0
	
xloop:
	move.l	a2,d0

	movem.l	d1-d7/a2-a6,-(a7)
	move	d0,d3
	moveq	#0,d4			; q1 = 0
	moveq	#0,d5			; q2 = 0
	moveq	#0,d6			; x  = 0
	moveq	#0,d7			; y  = 0
	subq	#1,d3

mandelloop2:
	move.l	d6,d1			; D1 = oldx;
	move.l	d4,d6
	sub.l	d5,d6
	add.l	a0,d6			; x(D6) = q1(D4) - q2(D5) + acoo(A0)
	move.l	d1,d2
	bpl.s	Pos1
	neg.l	d1
Pos1:
	eor.l	d7,d2
	tst.l	d7
	bpl.s	Pos2
	neg.l	d7
Pos2:
	move.l	d1,d0
	swap	d0
	move	d0,d2
	mulu	d7,d0
	clr	d0
	swap	d0
	swap	d7
	mulu	d7,d1
	clr	d1
	swap	d1
	mulu	d2,d7
	add.l	d0,d7
	add.l	d1,d7
	tst.l	d2
	bpl.s	Pos3
	neg.l	d7
Pos3:
	moveq	#6,d0
	asl.l	d0,d7
	add.l	a1,d7		; y(D7) = 2 * oldx(D1) * y(D7) + bcoo(A1)
	moveq	#5,d0
	move.l	d7,d5
	bpl.s	Pos4
	neg.l	d5
Pos4:
	move.l	d5,d2
	swap	d5
	mulu	d5,d2
	clr	d2
	swap	d2
	mulu	d5,d5
	add.l	d2,d5
	add.l	d2,d5
	asl.l	d0,d5			; q2(D4) = y(D7)^2;
	bvs.s	mandelexit
	move.l	d6,d4
	bpl.s	Pos5
	neg.l	d4
Pos5:
	move.l	d4,d2
	swap	d4
	mulu	d4,d2
	clr	d2
	swap	d2
	mulu	d4,d4
	add.l	d2,d4
	add.l	d2,d4
	asl.l	d0,d4		; q1(D4) = x(D6)^2;
	bvs.s	mandelexit
	move.l	d4,d0
	add.l	d5,d0
	bvs.s	mandelexit
	cmp.l	#536870912,d0	;$8000000 * 4
	bgt.s	mandelexit
	dbf	d3,mandelloop2

	moveq	#1,d3
mandelexit:
	subq	#1,d3
	move.l	d3,d0
	movem.l	(a7)+,d1-d7/a2-a6

	tst	d0
	beq.s	nextx

	movem.l	d2-d4/a4,-(sp)	
	move.l	d3,d2
	lsr	#3,d3
	add	d3,d4
	and	d7,d2
	eor.b	d6,d2
	add.l	d4,a4

	lsr	d0
	bcc.s	nobp0
	bset	d2,(a4)
nobp0:
	add	a3,a4
	lsr	d0
	bcc.s	nobp1
	bset	d2,(a4)
nobp1:
	add	a3,a4
	lsr	d0
	bcc.s	nobp2
	bset	d2,(a4)
nobp2:
	add	a3,a4
	lsr	d0
	bcc.s	nobp3
	bset	d2,(a4)
nobp3:
	add	a3,a4
	lsr	d0
	bcc.s	nobp4
	bset	d2,(a4)
nobp4:

pix_err:	movem.l	(sp)+,d2-d4/a4

nextx:
	sub.l	d1,a0
	btst	#6,$bfe001
	beq.s	MouseWait
	dbra	d3,xloop

nexty:
	add.l	d2,a1
	add	#40,d4
	cmp	#(200*40),d4
	blt	yloop

MouseWait:
	rts

;*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
;*+*+*+*+*+*+*+*+*+*+*+- Labels -+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+

;Alter these values for your different patterns !
Values	dc.l	$199999			;X value
	dc.l	$28f5c2			;Y value

;*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
;*+*+*+*+*+*+*+*+*+*+*+- Chip-Ram Stuff -+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+

	section	ChipRam,Code_c		;All copperlists/bitplanes/sound/
					;sprites/bobs etc. MUST be in
					;ChipRam !

;*+*+*+*+*+*+*+*+*+*+*+- Copper Lists -+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+

Copperlist:
	dc.w $0100,$5200		 ; bit plane control reg.0
	dc.w $0102,$0000		 ; scroll value
	dc.w $0104,$0000		 ; blp/sprite priority reg.
	dc.w $0108,$0000		 ; odd bitplane modulo value
	dc.w $010a,$0000		 ; even bitplane modulo value
	dc.w $0180,$0000
	dc.w $0182,$0100
	dc.w $0184,$0200
	dc.w $0186,$0300
	dc.w $0188,$0400
	dc.w $018a,$0500
	dc.w $018c,$0600
	dc.w $018e,$0700
	dc.w $0190,$0800
	dc.w $0192,$0900
	dc.w $0194,$0a00
	dc.w $0196,$0b00
	dc.w $0198,$0c00
	dc.w $019a,$0d00
	dc.w $019c,$0e00
	dc.w $019e,$0f00
	dc.w $01a0,$0fb0
	dc.w $01a2,$0001
	dc.w $01a4,$0002
	dc.w $01a6,$0003
	dc.w $01a8,$0004
	dc.w $01aa,$0005
	dc.w $01ac,$0006
	dc.w $01ae,$0007
	dc.w $01b0,$0008
	dc.w $01b2,$0009
	dc.w $01b4,$000a
	dc.w $01b6,$000b
	dc.w $01b8,$000c
	dc.w $01ba,$000d
	dc.w $01bc,$000e
	dc.w $01be,$000f

	dc.w $008e,$2c81		 ; upper left corner of disp. window
	dc.w $0090,$f4c1		 ; lower right corner of disp. window
	dc.w $0092,$0038		 ; start of bpl. (horizontal)
	dc.w $0094,$00d0		 ; endo of bpl. (horizontal)
bmapptrs:
	dc.w $00e0,$0000		 ; adr of bplane 1 (long - 2 words)
	dc.w $00e2,$0000		 ; low word of bplane 1 adr
	dc.w $00e4,$0000
	dc.w $00e6,$0000
	dc.w $00e8,$0000
	dc.w $00ea,$0000
	dc.w $00ec,$0000
	dc.w $00ee,$0000
	dc.w $00f0,$0000
	dc.w $00f2,$0000

	dc.l $fffffffe
	dc.l $fffffffe

;*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
	section	BSSBuffers,BSS_c	;Store screens and null data in a
					;BSS section
Bmap:
	dcb.b	8000*5,0
