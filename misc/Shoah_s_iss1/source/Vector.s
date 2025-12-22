;	  _______  ___                    ___        _______
;	 /░-     \/. /    _____   ____   / ./       /░-     \
;	 \   \___//  \___/░    \_/░   \_/   \___    \   \___/
;	_/\__    \      ~\_  /\  \  /\ ~\      ░\_ _/\__    \
;	\\       /   /\   /  \/. /  \/   \ //\   / \\       /
;	 \______/\__/  \_/\_____/\____/\_/_/  \_/ o \______/ Issue 1

***********************************************************
* й 1992 Epsilon
*
* This is just some crummy filled convex vectors.  This source is very
* slow, but it works.
*
* I'd like to thank Tip, of SpreadPoint, for writing and spreading what
* is quite possibly the fastest line drawing routine for the Amiga.  I
* modified it just a little bit so that it would work in multiple colors.
* The original version should also be found in this archive, if it isn't
* then contact me.
*
* I can be reached at:
*			Epsilon
*			P.O.B. 1914
*			Beaverton, OR  97075-1914
*			U.S.A.
* Or, you can e-mail me at:
*			idr@rigel.cs.pdx.edu
* Enjoy!
***********************************************************

;*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
;*+*+*+								  *+*+*+
;*+*+*+	I re-wrote the startup code for this to make it A1200	  *+*+*+
;*+*+*+	compatable, and generally altered things to make it run	  *+*+*+
;*+*+*+	a little bit quicker, oh and I made the colour scheme a	  *+*+*+
;*+*+*+	bit nicer ( I think so anyway ). If you use this routine  *+*+*+
;*+*+*+	then please credit Epsilon, NOT me, I didn't do any of    *+*+*+
;*+*+*+	the hard work !			Squize 16/12/94		  *+*+*+
;*+*+*+								  *+*+*+
;*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*

	opt c-				;Always set this !

	Section	Vector,Code		;Always put the code in public mem,
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
	lea	$dff000,a5			;Point to the hardware
	lea	labels,a4			;Speeds things up a tiny bit

	Copper_Set	Copperlist		;This is my macro for turning
						;on the copperlist
	move.l	#Cube,CurrentObject-labels(a4)
	move	#600,Scale-labels(a4)		;Alter this for a different
						;sized cube
	move	#5,XInc-labels(a4)		;Alter these to make it spin
	move	#1,YInc-labels(a4)		;differently
	move	#2,ZInc-labels(a4)

	move	#%1000001111000000,$96(a5)	;DMA:Blit/Bitpl/Copper

	bsr	Main				;Now run the main loop

	rts

;*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
;*+*+*+*+*+*+*+*+*+*+*+- The Main Loop -+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
;*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
MAIN:
	VBlank				;Wait for...

;*+*+*+	Vector routine

	bsr	CLS			;Clear the screen (With the blitter)
	bsr	Rotate			;Do the magic xyz thing
	bsr	FlipBmaps		;Double buffering

;*+*+*+	Check for quit

	Mouse_button	Main		;Another macro, if the left mouse
					;button is not pressed then it'll
					;loop to main
	rts				;LMB pressed, so return to "Init"

;*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
;*+*+*+*+*+*+*+*+*+*+*+- Subroutines -+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
;*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*

;*+*+*+*+*+*+*+*+*+*+*+- Double buffering -+*+*+*+*+*+*+*+*+*+*+*+*+*+*+
FlipBmaps:
	move.l	ActiveBmap-labels(a4),d0
	move.l	VisualBmap-labels(a4),ActiveBmap-labels(a4)
	move.l	d0,VisualBmap-labels(a4)

Screen_Pointers:
	lea	BmapPtrs+2,a0
	move.l	VisualBmap-labels(a4),d0
	move.l	#8000,d7

	move.l	d0,d1
	move	d1,4(a0)
	swap	d1
	move	d1,(a0)
	add.l	d7,d0
	move.l	d0,d1
	move	d1,12(a0)
	swap	d1
	move	d1,8(a0)
	add.l	d7,d0
	move	d0,20(a0)
	swap	d0
	move	d0,16(a0)
	rts

;*+*+*+*+*+*+*+*+*+*+*+- CLS -+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
CLS:
	move.l	ActiveBmap,a0			;Point to the work screen
	addq.l	#6,a0				;and clear it using nice
	Blitter_Wait				;Mr.Blitter...
	move	#12,$66(a5)
	move.l	#$01000000,$40(a5)
	Blitter_D	a0
	Blit_Size	#(600*64)+14
	rts

;*+*+*+*+*+*+*+*+*+*+*+- Rotate the points -+*+*+*+*+*+*+*+*+*+*+*+*+*+*
Rotate:
	lea	SineData-labels(a4),a2
	lea	CosineData-labels(a4),a3
	moveq	#0,d5
	move	XAngle-labels(a4),d5
	add.l	d5,d5				;d5 * 2 (byte offset)
	move	(a2,d5),SinX-labels(a4)		;d3 = sin(xa)
	move	(a3,d5),CosX-labels(a4)		;d4 = cos(xa)

	move	YAngle-labels(a4),d5
	add.l	d5,d5				;d5 * 2 (byte offset)
	move	(a2,d5),SinY-labels(a4)		;d3 = sin(ya)
	move	(a3,d5),CosY-labels(a4)		;d4 = cos(ya)

	move	ZAngle-labels(a4),d5
	add.l	d5,d5				;d5 * 2 (byte offset)
	move	(a2,d5),SinZ-labels(a4)		;d3 = sin(za)
	move	(a3,d5),CosZ-labels(a4)		;d4 = cos(za)
	
	move.l	CurrentObject-labels(a4),a0
	lea	OutputCoords-labels(a4),a1

	move	(a0)+,d7			;d7 = num of coords
	subq	#1,d7
		
CalcLoop:
	movem	(a0)+,d0-d2			;x,y,z coord
		
;X rotation
	movem.l	d1/d2,-(sp)			;save x,y,z
	muls	CosX-labels(a4),d1		;d1 = y * cos(xa)
	muls	SinX-labels(a4),d2		;d2 = z * sin(xa)
	add.l	d2,d1				;d1 = (y*cos(xa))+(z*sin(xa))
	move.l	d1,d5				;d5 = temporary y
	movem.l	(sp)+,d1/d2
	muls	CosX-labels(a4),d2		;d2 = z * cos(xa)
	muls	SinX-labels(a4),d1		;d1 = y * sin(xa)
	sub.l	d1,d2				;d2 = (z*cos(xa))-(y*sin(xa))
	move.l	d5,d1

	lsr.l	#8,d1
	lsr.l	#8,d2

;Y rotation
	movem.l	d0/d2,-(sp)			;save x,y,z
	muls	CosY-labels(a4),d0		;d0 = x * cos(ya)
	muls	SinY-labels(a4),d2		;d2 = z * sin(ya)
	sub.l	d2,d0				;d0 = (x*cos(ya))-(z*sin(ya))
	move.l	d0,d5				;d5 = temporary x
	movem.l	(sp)+,d0/d2
	muls	CosY-labels(a4),d2		;d2 = z * cos(ya)
	muls	SinY-labels(a4),d0		;d0 = x * sin(ya)
	add.l	d0,d2				;d2 = (z*cos(ya))+(y*sin(ya))
	move.l	d5,d0

	lsr.l	#8,d0
	lsr.l	#8,d2	

;Z rotation
	movem.l	d0/d1,-(sp)			;save x,y,z
	muls	CosZ-labels(a4),d0		;d0 = x * cos(za)
	muls	SinZ-labels(a4),d1		;d1 = y * sin(za)
	sub.l	d1,d0				;d0 = (x*cos(za))-(y*sin(za))
	move.l	d0,d5				;d5 = temporary x
	movem.l	(sp)+,d0/d1
	muls	SinZ-labels(a4),d0		;d0 = x * sin(za)
	muls	CosZ-labels(a4),d1		;d1 = y * cos(za)
	add.l	d0,d1				;d1 = (y*cos(za))+(x*sin(za))
	move.l	d5,d0

	add	Scale-labels(a4),d2		
	divs	d2,d0
	divs	d2,d1

	add	#160,d0
	add	#100,d1

	move	d0,(a1)+			;Store output coordinates
	move	d1,(a1)+
	dbra	d7,CalcLoop

	move	XInc-labels(a4),d0
	add	d0,XAngle-labels(a4)
	cmp	#360,XAngle-labels(a4)
	blt.s	NoXAngleReset
	clr	XAngle-labels(a4)

NoXAngleReset:	
	move	YInc-labels(a4),d0
	add	d0,YAngle-labels(a4)
	cmp	#360,YAngle-labels(a4)
	blt.s	NoYAngleReset
	clr	YAngle-labels(a4)
NoYAngleReset:	
	move	ZInc-labels(a4),d0
	add	d0,ZAngle-labels(a4)
	cmp	#360,ZAngle-labels(a4)
	blt.s	NoZAngleReset
	clr	ZAngle-labels(a4)
NoZAngleReset:

;*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
DrawPoly:
	moveq.l	#0,d0
	moveq.l	#0,d1
	moveq.l	#0,d2
	moveq.l	#0,d3
	moveq.l	#0,d5	

	lea	OutputCoords-labels(a4),a1
	move	(a0)+,d7			;d7 = number of surfaces
	move	d7,num_faces-labels(a4)
		
	bsr	DL_Init

SurfaceLoop:
	move	(a0)+,d6		;d6 = number of points this surface
	move	(a0)+,colour-labels(a4)

	bsr	CheckFace		;check the visibility of the surface
	cmp.l	d0,d1			;can we see it?
	bge.s	face_ok			;yes.

	add	d6,d6
	add	d6,a0		
	bra	dont_do_it

face_ok:
	subq	#2,d6
		
PointLoop:
	move	(a0)+,d5		;d5 = point number
	subq	#1,d5
	lsl	#2,d5

	move	d5,-(sp)		;save for later...
	move	(a1,d5),d0
	move	2(a1,d5),d1		;d0,d1 are first coord
GetPoint:		
	move	(a0)+,d5
	subq	#1,d5
	lsl	#2,d5
	move	(a1,d5),d2
	move	2(a1,d5),d3		;d2,d3 are second coord
	bsr	DrawLine		;draw the line

	cmp	#3,colour-labels(a4)
	bne.s	no_colour_3
	move	#2,colour-labels(a4)
	bsr	DrawLine
	move	#3,colour-labels(a4)
no_colour_3:
	move	d2,d0
	move	d3,d1
	dbra	d6,GetPoint

	move	(sp)+,d5		;the first point
	move	(a1,d5),d2
	move	2(a1,d5),d3		;d2,d3 are second coord
do_line2:
	bsr	DrawLine		;draw the line
	cmp	#3,colour-labels(a4)
	bne.s	dont_do_it
	move	#2,colour-labels(a4)
	bra.s	do_line2

dont_do_it:
	dbra	d7,SurfaceLoop

;*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
FillSurface:
	move.l	ActiveBmap-labels(a4),a2
	add.l	#(24000-2-6),a2
	move.l	#$000c000c,d1
	move	#(600*64)+14,d4

	Blitter_Wait
		
	move.l	#$09f00012,$40(a5)	;Miniterms
	move.l	d1,$64(a5)		;A/D Modulo
	Blitter_A	a2
	Blitter_D	a2
	Blit_Size	d4
	rts
		
;*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
x1		EQUR	d0
y1		EQUR	d1
x2		EQUR	d2
y2		EQUR	d3
x3		EQUR	d4
y3		EQUR	d5
dx1		EQUR	d1
dy1		EQUR	d7
dx2		EQUR	d0
dy2		EQUR	d6

CheckFace:
	movem.l	d6-d7/a0,-(sp)
	move	(a0)+,d5		;d5 = point number
	subq	#1,d5
	lsl	#2,d5
	move	(a1,d5),x1
	move	2(a1,d5),y1		;d0,d1 are first coord

	move	(a0)+,d5
	subq	#1,d5
	lsl	#2,d5
	move	(a1,d5),x2
	move	2(a1,d5),y2		;d2,d3 are second coord

	move	(a0)+,d5
	subq	#1,d5
	lsl	#2,d5
	move	(a1,d5),x3
	move	2(a1,d5),y3		;d4,d5 are third coord

	move	y1,dy1
	sub	y2,dy1			;find delta y for first line
	move	y2,dy2
	sub	y3,dy2			;find delta y for second line
	move	x1,dx1
	sub	x2,dx1			;find delta x for first line
	move	x2,dx2
	sub	x3,dx2			;find delta x for second line

	muls	dy1,dx2			;here I just "cross multiply"
	muls	dy2,dx1			;the two slopes
	movem.l	(sp)+,d6-d7/a0
	rts

*******************************************************************************
*			'DrawLine V1.01' By TIP/SPREADPOINT		      *
*******************************************************************************

DL_Width	=	40
DL_Fill		=	1		;0=NOFILL / 1=FILL
	IFEQ	DL_Fill
DL_MInterns	=	$CA
	ELSE
DL_MInterns	=	$4A
	ENDC

;нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
;	A0 = PlanePtr, A6 = $DFF002, D0/D1 = X0/Y0, D2/D3 = X1/Y1
;	D4 = PlaneWidth > Kills: D0-D4/A0-A1 (+D5 in Fill Mode)

DrawLine:
	movem.l	d0-d5/a0-a1,-(sp)
	move.l	ActiveBmap-labels(a4),a0
	cmp	#2,colour-labels(a4)	;if it's colour 2 we don't draw in
	bne.s	no_plane_2
	add.l	#8000,a0		;   bpl one or three.
no_plane_2:		
	cmp	#4,colour-labels(a4)	;if it's colour 4 we don't draw in
	bne.s	no_plane_3
	adda.l	#16000,a0		;   bpl one or two.
no_plane_3:
	cmp	d1,d3			;Drawing only from Top to Bottom is
	bge.s	.y1ly2			;necessary for:
	exg	d0,d2			; 1) Up-down Differences (same coords)
	exg	d1,d3			; 2) Blitter Invert Bit (only at top of
					;    line)
.y1ly2:
	sub	d1,d3			;D3 = yd

; Here we could do an Optimization with Special Shifts
; depending on the DL_Width value... I know it, but please, let it be.

	mulu	#40,d1			;Use muls for neg Y-Vals

	add.l	d1,a0			;Please don't use add.w here !!!
	moveq	#0,d1			;D1 = Quant-Counter
	sub	d0,d2			;D2 = xd
	bge.s	.xdpos
	addq	#2,d1			;Set Bit 1 of Quant-Counter (here it
					;could be a moveq)
	neg.w	d2
.xdpos:
	moveq	#$f,d4			;D4 full cleaned (for later oktants
					;move.b)
	and	d0,d4
	IFNE	DL_Fill
		move.b	d4,d5		;D5 = Special Fill Bit
		not.b	d5
	ENDC
	lsr	#3,d0			;Yeah, on byte (necessary for bchg)...
	add	d0,a0			;...Blitter ands automagically
	ror	#4,d4			;D4 = Shift
	or	#$B00+DL_MInterns,d4	;BLTCON0-codes
	swap	d4
	cmp	d2,d3			;Which Delta is the Biggest ?
	bge.s	.dygdx
	addq	#1,d1			;Set Bit 0 of Quant-Counter
	exg	d2,d3			;Exchange xd with yd
.dygdx:
	add	d2,d2			;D2 = xd*2
	move	d2,d0			;D0 = Save for $52(a6)
	sub	d3,d0			;D0 = xd*2-yd
	addx	d1,d1			;Bit0 = Sign-Bit
	move.b	Oktants(pc,d1),d4	;In Low Byte of d4
					;(upper byte cleaned above)
	swap	d2
	move	d0,d2
	sub	d3,d2			;D2 = 2*(xd-yd)
	moveq	#6,d1			;D1 = ShiftVal (not necessary) 
					;+ TestVal for the Blitter
	lsl	d1,d3			;D3 = BLTSIZE
	add	#$42,d3
	lea	$52(a5),a1		;A1 = CUSTOM+$52
rept:
	Blitter_Wait

	IFNE	DL_Fill
		bchg	d5,(a0)		;Inverting the First Bit of Line
	ENDC
	move.l	d4,$40(a5)		;Writing to the Blitter Regs as fast
	move.l	d2,$62(a5)		;as possible
	move.l	a0,$48(a5)
	move.w	d0,(a1)+
	move.l	a0,(a1)+		;Shit-Word Buffer Ptr...
	move.w	d3,(a1)
	movem.l	(sp)+,d0-d5/a0-a1
	rts
;нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
	IFNE	DL_Fill
SML		= 	2
	ELSE
SML		=	0
	ENDC

Oktants:
	dc.b	SML+1,SML+1+$40
	dc.b	SML+17,SML+17+$40
	dc.b	SML+9,SML+9+$40
	dc.b	SML+21,SML+21+$40
;нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
;		Optimized Init Part... A5 = $DFF000 > Kills : D0-D2

DL_Init:
	movem.l	d0-d2,-(sp)
	moveq	#-1,d1
	IFGT	DL_Width-127
		move	#DL_Width,d0
	ELSE
		moveq	#DL_Width,d0
	ENDC
		moveq	#6,d2
	Blitter_Wait
	move	d1,$44(a5)
	move	d1,$72(a5)
	move	#$8000,$74(a5)
	move	d0,$60(a5)
	move	d0,$66(a5)
	movem.l	(sp)+,d0-d2
	rts

;*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
;*+*+*+*+*+*+*+*+*+*+*+- Labels -+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+
Labels:
SineData:
	dc.l $00000004,$0008000D,$00110016,$001A001F,$00230028,$002C0030,$00350039
	dc.l $003D0042,$0046004A,$004F0053,$0057005B,$005F0064,$0068006C,$00700074
	dc.l $0078007C,$00800083,$0087008B,$008F0092,$0096009A,$009D00A1,$00A400A7
	dc.l $00AB00AE,$00B100B5,$00B800BB,$00BE00C1,$00C400C6,$00C900CC,$00CF00D1
	dc.l $00D400D6,$00D900DB,$00DD00DF,$00E200E4,$00E600E8,$00E900EB,$00ED00EE
	dc.l $00F000F2,$00F300F4,$00F600F7,$00F800F9,$00FA00FB,$00FC00FC,$00FD00FE
	dc.l $00FE00FF,$00FF00FF,$00FF00FF
CosineData:
	dc.l $010000FF,$00FF00FF,$00FF00FF,$00FE00FE,$00FD00FC,$00FC00FB,$00FA00F9
	dc.l $00F800F7,$00F600F4,$00F300F2,$00F000EE,$00ED00EB,$00E900E8,$00E600E4
	dc.l $00E200DF,$00DD00DB,$00D900D6,$00D400D1,$00CF00CC,$00C900C6,$00C400C1
	dc.l $00BE00BB,$00B800B5,$00B100AE,$00AB00A7,$00A400A1,$009D009A,$00960092
	dc.l $008F008B,$00870083,$007F007C,$00780074,$0070006C,$00680064,$005F005B
	dc.l $00570053,$004F004A,$00460042,$003D0039,$00350030,$002C0028,$0023001F
	dc.l $001A0016,$0011000D,$00080004,$FFFFFFFB,$FFF7FFF2,$FFEEFFE9,$FFE5FFE0
	dc.l $FFDCFFD7,$FFD3FFCF,$FFCAFFC6,$FFC2FFBD,$FFB9FFB5,$FFB0FFAC,$FFA8FFA4
	dc.l $FFA0FF9B,$FF97FF93,$FF8FFF8B,$FF87FF83,$FF7FFF7C,$FF78FF74,$FF70FF6D
	dc.l $FF69FF65,$FF62FF5E,$FF5BFF58,$FF54FF51,$FF4EFF4A,$FF47FF44,$FF41FF3E
	dc.l $FF3BFF39,$FF36FF33,$FF30FF2E,$FF2BFF29,$FF26FF24,$FF22FF20,$FF1DFF1B
	dc.l $FF19FF17,$FF16FF14,$FF12FF11,$FF0FFF0D,$FF0CFF0B,$FF09FF08,$FF07FF06
	dc.l $FF05FF04,$FF03FF03,$FF02FF01,$FF01FF00,$FF00FF00,$FF00FF00,$FF00FF00
	dc.l $FF00FF00,$FF00FF00,$FF01FF01,$FF02FF03,$FF03FF04,$FF05FF06,$FF07FF08
	dc.l $FF09FF0B,$FF0CFF0D,$FF0FFF11,$FF12FF14,$FF16FF17,$FF19FF1B,$FF1DFF20
	dc.l $FF22FF24,$FF26FF29,$FF2BFF2E,$FF30FF33,$FF36FF39,$FF3BFF3E,$FF41FF44
	dc.l $FF47FF4A,$FF4EFF51,$FF54FF58,$FF5BFF5E,$FF62FF65,$FF69FF6D,$FF70FF74
	dc.l $FF78FF7C,$FF80FF83,$FF87FF8B,$FF8FFF93,$FF97FF9B,$FFA0FFA4,$FFA8FFAC
	dc.l $FFB0FFB5,$FFB9FFBD,$FFC2FFC6,$FFCAFFCF,$FFD3FFD7,$FFDCFFE0,$FFE5FFE9
	dc.l $FFEEFFF2,$FFF7FFFB,$00000004,$0008000D,$00110016,$001A001F,$00230028
	dc.l $002C0030,$00350039,$003D0042,$0046004A,$004F0053,$0057005B,$005F0064
	dc.l $0068006C,$00700074,$0078007C,$00800083,$0087008B,$008F0092,$0096009A
	dc.l $009D00A1,$00A400A7,$00AB00AE,$00B100B5,$00B800BB,$00BE00C1,$00C400C6
	dc.l $00C900CC,$00CF00D1,$00D400D6,$00D900DB,$00DD00DF,$00E200E4,$00E600E8
	dc.l $00E900EB,$00ED00EE,$00F000F2,$00F300F4,$00F600F7,$00F800F9,$00FA00FB
	dc.l $00FC00FC,$00FD00FE,$00FE00FF,$00FF00FF,$00FF00FF

ActiveBmap	dc.l	Bmap2
VisualBmap 	dc.l	Bmap1
CurrentObject	dc.l	Cube
FaceList	ds.l	20

Cube:
	dc.w	8			; number of unique points
	dc.w	0100,0100,0100
	dc.w	0100,-100,0100
	dc.w	-100,-100,0100
	dc.w	-100,0100,0100
	dc.w	0100,0100,-100
	dc.w	0100,-100,-100
	dc.w	-100,-100,-100
	dc.w	-100,0100,-100
	dc.w	5			; number of surfaces - 1
	dc.w	4,1			; number of pts in surface 1
	dc.w	4,1,2,3			; pt numbers
	dc.w	4,1
	dc.w	5,8,7,6
	dc.w	4,2
	dc.w	5,6,2,1
	dc.w	4,3
	dc.w	4,8,5,1
	dc.w	4,2
	dc.w	4,3,7,8
	dc.w	4,3
	dc.w	2,6,7,3

colour		ds.w	1
num_faces	ds.w	1
SinX		ds.w	1
CosX		ds.w	1
SinY		ds.w	1
CosY		ds.w	1
SinZ		ds.w	1
CosZ		ds.w	1
XAngle		ds.w	1
YAngle		ds.w	1
ZAngle		ds.w	1
Scale		ds.w	1
XInc		ds.w	1
YInc		ds.w	1
ZInc		ds.w	1
OutputCoords	ds.w	1
		ds.w	2*42

;*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
;*+*+*+*+*+*+*+*+*+*+*+- Chip-Ram Stuff -+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+

	section	ChipRam,Code_c		;All copperlists/bitplanes/sound/
					;sprites/bobs etc. MUST be in
					;ChipRam !

;*+*+*+*+*+*+*+*+*+*+*+- Copper Lists -+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+

Copperlist:
	dc.l $01003200			;Only 3 bitplanes
	dc.l $01020000
	dc.l $01040000
	dc.l $01080000,$010a0000	;Modulos

	dc.l $00920038,$009400d0
	dc.l $008e2cc1,$0090f4c1

	dc.w $0180,$0000		;Colours
	dc.w $0182,$0779
	dc.w $0184,$088a
	dc.w $0186,$099b
	dc.w $0188,$0aac

BmapPtrs
	dc.l $00e00000
	dc.l $00e20000
	dc.l $00e40000
	dc.l $00e60000
	dc.l $00e80000
	dc.l $00ea0000

	dc.l $fffffffe
	dc.l $fffffffe

;*+*+*+*+*+*+*+*+*+*+*+- Buffers -+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*

Bmap1:		ds.b	24000
Bmap2:		ds.b	24000
