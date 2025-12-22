;	  _______  ___                    ___        _______
;	 /°-     \/. /    _____   ____   / ./       /°-     \
;	 \   \___//  \___/°    \_/°   \_/   \___    \   \___/
;	_/\__    \      ~\_  /\  \  /\ ~\      °\_ _/\__    \
;	\\       /   /\   /  \/. /  \/   \ //\   / \\       /
;	 \______/\__/  \_/\_____/\____/\_/_/  \_/ o \______/ Issue 1

;Plasma
;The original source was by Rene Olsthoorn, for Newsflash...
;Tidied up and made A1200 compatable by Squize	15/12/94

	opt c-				;Always set this !

	Section	Plasma,Code		;Always put the code in public mem,
					;so people with Fast Ram get the
					;benefit

;*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*

	include	SHOAH.s:SHOAH_Libs/Macros.lib
					;I've made some nice macros to
					;make life that little bit easier

;*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*

plasma_lines	equ	210-1		;Number of lines ( Don't put too big
					;a value here ! )

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
	lea	$dff000,a5

	lea	plasma_copper,a0
	move	#$203f,a1		;This value is the top position of
	move	#plasma_lines,d2	;the plasma...
.plasma_cop_loop
	add	#$0100,a1		;This routine fills a buffer within
	move	a1,(a0)+		;the actual copperlist with colour &
	move	#$fffe,(a0)+		;wait commands ( It's about a million
	move	#5-1,d3			;times easier than typing in all in
.plasma_sub_cop_loop			;by hand ! )
	move	#$0194,(a0)+		;comb 1010
	clr	(a0)+
	move	#$019a,(a0)+		;comb 1101
	clr	(a0)+
	move	#$018c,(a0)+		;comb 0110
	clr	(a0)+
	move	#$0196,(a0)+		;comb 1011
	clr	(a0)+
	move	#$018a,(a0)+		;comb 0101
	clr	(a0)+
	move	#$0184,(a0)+		;comb 0010
	clr	(a0)+
	move	#$0192,(a0)+		;comb 1001
	clr	(a0)+
	move	#$0188,(a0)+		;comb 0100
	clr	(a0)+
	dbra	d3,.plasma_sub_cop_loop
	dbra	d2,.plasma_cop_loop

	move.l	#plasma_plane,d0	;Set up the plane pointers (This
	move.w	d0,BITPL1+6		;program use 4 bitplanes, ie 16 cols)
	swap	d0
	move.w	d0,BITPL1+2
	move.l	#plasma_plane+2,d0
	move.w	d0,BITPL2+6
	swap	d0
	move.w	d0,BITPL2+2
	move.l	#plasma_plane+2,d0
	move.w	d0,BITPL3+6
	swap	d0
	move.w	d0,BITPL3+2
	move.l	#plasma_plane+4,d0
	move.w	d0,BITPL4+6
	swap	d0
	move.w	d0,BITPL4+2

	Copper_Set	CopperList
	move	#%1000001111000000,$96(a5)	;DMA:Blit/Bitpl/Copper

	bsr.s	Main				;Now run the main loop

	rts					;All done, so go back to
						;"RestoreSystem"

;*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
;*+*+*+*+*+*+*+*+*+*+*+- The Main Loop -+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
;*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
MAIN:
	VBlank

;*+*+*+	Run the plasma jazz

	bsr	Plasma_Horizontal
	bsr	Plasma_Figuur
	lea	$dff000,a5

;*+*+*+	Check for quit

	Mouse_button	Main		;Loop to MAIN, until LMB pressed
	rts

;*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
Plasma_Horizontal:
	move.l	#$ffffffff,$44(a5)
	move	#$0000,$42(a5)
	move.l	#$00000006,$64(a5)
	lea	plasma_regel,a3

	lea	plasma_plane,a0
	move.l	fhor,d7

	move	qhor,d4
	lea	plasma_sinus,a1
	add	d4,plasma_sinus_add
	add	plasma_sinus_add,a1
	cmp.l	#end_plasma_sinus,a1
	bcs.s	reset_add
	sub.l	#end_plasma_sinus,a1
	move	a1,plasma_sinus_add
	add.l	#plasma_sinus,a1
reset_add:
	move	#plasma_lines,d2

place_loop:
	moveq	#0,d0
	move.b	(a1),d0
	add.l	d7,a1
	cmp.l	#end_plasma_sinus,a1
	bcs.s	double_boble
	sub.l	#end_plasma_sinus-plasma_sinus,a1
double_boble:
	move.b	d0,d1
	and.b	#$f0,d1
	lsr.b	#3,d1
	and.b	#$0f,d0
	ror	#4,d0

	or	#%0000100111110000,d0
	move	d0,$40(a5)	
	add.l	d1,a0
	Blitter_A	a3
	Blitter_D	a0
	Blit_Size	#1*64+19
	Blitter_Wait

	sub.l	d1,a0
	lea	44(a0),a0
	dbra	d2,place_loop
	rts

;*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
plasma_figuur:
	move.l	#$ffffffff,$44(a5)
	move.l	#$0ffe0000,$40(a5)	
	moveq.l	#$00,d0
	move	d0,$64(a5)
	move.l	d0,$60(a5)
	move	#162,$66(a5)

	move.l	fig1(pc),d5
	move.l	d5,a0
	move.l	fig2(pc),d5
	move.l	d5,a1
	move.l	fig3(pc),d5
	move.l	d5,a2
	lea	plasma_copper+6,a3	;dest.

	move.l	fvert1(pc),d5
	move.l	fvert2(pc),d6
	move.l	fvert3(pc),d7

	move	qvert1(pc),d4
	lea	plasma_verticaal,a4
	add	d4,figuur_teller1
	add	figuur_teller1(pc),a4
	cmp.l	#end_plasma_verticaal,a4
	bcs.s	reset_add1
	sub.l	#end_plasma_verticaal,a4
	move	a4,figuur_teller1
	add.l	#plasma_verticaal,a4
reset_add1:

	move	qvert2(pc),d4
	lea	plasma_verticaal,a5
	add	d4,figuur_teller2
	add	figuur_teller2(pc),a5
	cmp.l	#end_plasma_verticaal,a5
	bcs.s	reset_add2
	sub.l	#end_plasma_verticaal,a5
	move	a5,figuur_teller2
	add.l	#plasma_verticaal,a5
reset_add2:

	move	qvert3(pc),d4
	lea	plasma_verticaal,a6
	add	d4,figuur_teller3
	add	figuur_teller3(pc),a6
	cmp.l	#end_plasma_verticaal,a6
	bcs.s	reset_add3
	sub.l	#end_plasma_verticaal,a6
	move	a6,figuur_teller3
	add.l	#plasma_verticaal,a6
reset_add3:
	
	moveq	#5*8-6-1,d3

perfect_loop:
	moveq	#0,d0
	move.b	(a4),d0
	add.l	d5,a4
	cmp.l	#end_plasma_verticaal,a4
	bcs.s	reset_raket1
	sub.l	#end_plasma_verticaal-plasma_verticaal,a4
reset_raket1:
	lsl	#1,d0
	add.l	d0,a0

	moveq	#0,d1
	move.b	(a5),d1
	add.l	d6,a5
	cmp.l	#end_plasma_verticaal,a5
	bcs.s	reset_raket2
	sub.l	#end_plasma_verticaal-plasma_verticaal,a5
reset_raket2:
	lsl	#1,d1
	add.l	d1,a1

	moveq	#0,d2
	move.b	(a6),d2
	add.l	d7,a6
	cmp.l	#end_plasma_verticaal,a6
	bcs.s	reset_raket3
	sub.l	#end_plasma_verticaal-plasma_verticaal,a6
reset_raket3:
	lsl	#1,d2
	add.l	d2,a2

	move.l	a5,-(a7)
	lea	$dff000,a5
	Blitter_A	a0
	Blitter_B	a1
	Blitter_C	a2
	Blitter_D	a3
	Blit_Size	#210*64+1
	Blitter_Wait
	move.l	(a7)+,a5
	sub.l	d0,a0
	sub.l	d1,a1
	sub.l	d2,a2
	addq.l	#4,a3
	dbra	d3,perfect_loop
	rts

;*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
;*+*+*+*+*+*+*+*+*+*+*+- Labels -+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+
plasma_sinus_add dc.w	0
figuur_teller1	dc.w	0
figuur_teller2	dc.w	0
figuur_teller3	dc.w	0
qvert1		dc.w	4
qvert2		dc.w	3
qvert3		dc.w	2
fvert1		dc.l	4
fvert2		dc.l	5
fvert3		dc.l	6
fig1		dc.l	figuur1
fig2		dc.l	figuur2
fig3		dc.l	figuur3
qhor		dc.w	0
fhor		dc.l	60
step_counter	dc.w	0
fvert_extra	dc.l	figuur2

;*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
;*+*+*+*+*+*+*+*+*+*+*+- Chip-Ram Stuff -+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+

	section	ChipRam,Code_c		;All copperlists/bitplanes/sound/
					;sprites/bobs etc. MUST be in
					;ChipRam !

;*+*+*+*+*+*+*+*+*+*+*+- Copper Lists -+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+

	cnop	0,4

Copperlist:
	dc.w $0100,$0200 
	dc.w $0104,$0000
	dc.w $0102,%0000000010000000

	dc.w $0108
	dc.w $0004,$010A
	dc.w $0004
	dc.l $00920038,$009400d0	;DDFSTRT/DDFSTOP
	dc.l $008E29b8,$00902f90	;DIWSTRT/DIWSTOP

BITPL1:	dc.w $00e0,$0000,$00e2,$0000
BITPL2:	dc.w $00e4,$0000,$00e6,$0000
BITPL3:	dc.w $00e8,$0000,$00ea,$0000
BITPL4:	dc.w $00ec,$0000,$00ee,$0000

	dc.w $0180,$0000
		dc.l $210ffffe
	dc.w $0100,$4200

plasma_copper:
	dcb.w	(2*8*5+2)*210,0

	dc.w $0100,$0200
		dc.l $fffffffe
		dc.l $fffffffe

	cnop 0,4
plasma_plane:
	ds.b	44*255			;1 bitplane, normal overscan screen
	even

plasma_regel:
	dc.l	$00ff00ff,$ff00ff00
	dc.l	$00ff00ff,$ff00ff00
	dc.l	$00ff00ff,$ff00ff00
	dc.l	$00ff00ff,$ff00ff00
	dc.l	$00ff00ff,$ff00ff00
	dc.l	$00ff00ff
plasma_sinus:
	dc.b	27,27,27,28,28,28,28,29,29,29,29,30
	dc.b	30,30,30,31,31,31,31,31,32,32,32,32
	dc.b	33,33,33,33,34,34,34,34,34,35,35,35
	dc.b	35,36,36,36,36,36,37,37,37,37,38,38
	dc.b	38,38,38,39,39,39,39,39,40,40,40,40
	dc.b	40,41,41,41,41,42,42,42,42,42,42,43
	dc.b	43,43,43,43,44,44,44,44,44,45,45,45
	dc.b	45,45,45,46,46,46,46,46,46,47,47,47
	dc.b	47,47,47,48,48,48,48,48,48,48,49,49
	dc.b	49,49,49,49,49,50,50,50,50,50,50,50
	dc.b	50,50,51,51,51,51,51,51,51,51,51,52
	dc.b	52,52,52,52,52,52,52,52,52,52,53,53
	dc.b	53,53,53,53,53,53,53,53,53,53,53,53
	dc.b	53,53,54,54,54,54,54,54,54,54,54,54
	dc.b	54,54,54,54,54,54,54,54,54,54,54,54
	dc.b	54,54,54,54,54,54,54,54,54,54,54,54
	dc.b	54,54,54,54,54,54,54,54,54,54,54,53
	dc.b	53,53,53,53,53,53,53,53,53,53,53,53
	dc.b	53,53,53,52,52,52,52,52,52,52,52,52
	dc.b	52,52,51,51,51,51,51,51,51,51,51,50
	dc.b	50,50,50,50,50,50,50,50,49,49,49,49
	dc.b	49,49,49,48,48,48,48,48,48,48,47,47
	dc.b	47,47,47,47,46,46,46,46,46,46,45,45
	dc.b	45,45,45,45,44,44,44,44,44,43,43,43
	dc.b	43,43,42,42,42,42,42,42,41,41,41,41
	dc.b	41,40,40,40,40,39,39,39,39,39,38,38
	dc.b	38,38,38,37,37,37,37,36,36,36,36,36
	dc.b	35,35,35,35,34,34,34,34,34,33,33,33
	dc.b	33,32,32,32,32,31,31,31,31,31,30,30
	dc.b	30,30,29,29,29,29,28,28,28,28,27,27
	dc.b	27,27,27,26,26,26,26,25,25,25,25,24
	dc.b	24,24,24,23,23,23,23,23,22,22,22,22
	dc.b	21,21,21,21,20,20,20,20,20,19,19,19
	dc.b	19,18,18,18,18,18,17,17,17,17,16,16
	dc.b	16,16,16,15,15,15,15,15,14,14,14,14
	dc.b	14,13,13,13,13,12,12,12,12,12,12,11
	dc.b	11,11,11,11,10,10,10,10,10,9,9,9
	dc.b	9,9,9,8,8,8,8,8,8,7,7,7
	dc.b	7,7,7,6,6,6,6,6,6,6,5,5
	dc.b	5,5,5,5,5,4,4,4,4,4,4,4
	dc.b	4,4,3,3,3,3,3,3,3,3,3,2
	dc.b	2,2,2,2,2,2,2,2,2,2,1,1
	dc.b	1,1,1,1,1,1,1,1,1,1,1,1
	dc.b	1,1,0,0,0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,0,0,0,0,1
	dc.b	1,1,1,1,1,1,1,1,1,1,1,1
	dc.b	1,1,1,2,2,2,2,2,2,2,2,2
	dc.b	2,2,3,3,3,3,3,3,3,3,3,4
	dc.b	4,4,4,4,4,4,4,4,5,5,5,5
	dc.b	5,5,5,6,6,6,6,6,6,6,7,7
	dc.b	7,7,7,7,8,8,8,8,8,8,9,9
	dc.b	9,9,9,9,10,10,10,10,10,11,11,11
	dc.b	11,11,12,12,12,12,12,12,13,13,13,13
	dc.b	13,14,14,14,14,15,15,15,15,15,16,16
	dc.b	16,16,16,17,17,17,17,18,18,18,18,18
	dc.b	19,19,19,19,20,20,20,20,20,21,21,21
	dc.b	21,22,22,22,22,23,23,23,23,23,24,24
	dc.b	24,24,25,25,25,25,26,26,26,26,27,27
end_plasma_sinus:

plasma_verticaal:
	dc.b	27,27,28,28,29,29,30,30,31,31,32,32
	dc.b	33,33,34,34,34,35,35,36,36,37,37,38
	dc.b	38,38,39,39,40,40,40,41,41,42,42,42
	dc.b	43,43,44,44,44,45,45,45,46,46,46,47
	dc.b	47,47,48,48,48,49,49,49,49,50,50,50
	dc.b	50,51,51,51,51,51,52,52,52,52,52,53
	dc.b	53,53,53,53,53,53,53,54,54,54,54,54
	dc.b	54,54,54,54,54,54,54,54,54,54,54,54
	dc.b	54,54,54,54,54,54,53,53,53,53,53,53
	dc.b	53,53,52,52,52,52,52,51,51,51,51,51
	dc.b	50,50,50,50,49,49,49,49,48,48,48,47
	dc.b	47,47,46,46,46,45,45,45,44,44,44,43
	dc.b	43,42,42,42,41,41,41,40,40,39,39,38
	dc.b	38,38,37,37,36,36,35,35,34,34,34,33
	dc.b	33,32,32,31,31,30,30,29,29,28,28,27
	dc.b	27,27,26,26,25,25,24,24,23,23,22,22
	dc.b	21,21,20,20,20,19,19,18,18,17,17,16
	dc.b	16,16,15,15,14,14,14,13,13,12,12,12
	dc.b	11,11,10,10,10,9,9,9,8,8,8,7
	dc.b	7,7,6,6,6,5,5,5,5,4,4,4
	dc.b	4,3,3,3,3,3,2,2,2,2,2,1
	dc.b	1,1,1,1,1,1,1,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,1,1,1,1,1,1
	dc.b	1,1,2,2,2,2,2,3,3,3,3,3
	dc.b	4,4,4,4,5,5,5,5,6,6,6,7
	dc.b	7,7,8,8,8,9,9,9,10,10,10,11
	dc.b	11,12,12,12,13,13,13,14,14,15,15,16
	dc.b	16,16,17,17,18,18,19,19,20,20,20,21
	dc.b	21,22,22,23,23,24,24,25,25,26,26,27
end_plasma_verticaal:
figuur1:
	dc.w	$0f00,$0f00,$0f00,$0e00,$0e00,$0e00,$0d00,$0d00,$0d00
	dc.w	$0c00,$0c00,$0c00,$0b00,$0b00,$0b00,$0a00,$0a00,$0a00
	dc.w	$0900,$0900,$0900,$0800,$0800,$0800,$0700,$0700,$0700
	dc.w	$0600,$0600,$0600,$0500,$0500,$0500,$0400,$0400,$0400
	dc.w	$0300,$0300,$0300,$0200,$0200,$0200,$0100,$0100,$0100
	dcb.w	18,0
	dc.w	$0100,$0100,$0100,$0100,$0200,$0200,$0200,$0200
	dc.w	$0300,$0300,$0300,$0300,$0400,$0400,$0400,$0400
	dc.w	$0500,$0500,$0500,$0500,$0600,$0600,$0600,$0600
	dc.w	$0700,$0700,$0700,$0700,$0800,$0800,$0800,$0800
	dc.w	$0900,$0900,$0900,$0900,$0a00,$0a00,$0a00,$0a00
	dc.w	$0b00,$0b00,$0b00,$0b00,$0c00,$0c00,$0c00,$0c00
	dc.w	$0d00,$0d00,$0d00,$0d00,$0e00,$0e00,$0e00,$0e00
	dc.w	$0f00,$0f00,$0f00,$0f00

	dc.w	$0f00,$0f00,$0f00,$0f00,$0e00,$0e00,$0e00,$0e00
	dc.w	$0d00,$0d00,$0d00,$0d00,$0c00,$0c00,$0c00,$0c00
	dc.w	$0b00,$0b00,$0b00,$0b00,$0a00,$0a00,$0a00,$0a00
	dc.w	$0900,$0900,$0900,$0900,$0800,$0800,$0800,$0800
	dc.w	$0700,$0700,$0700,$0700,$0600,$0600,$0600,$0600
	dc.w	$0500,$0500,$0500,$0500,$0400,$0400,$0400,$0400
	dc.w	$0300,$0300,$0300,$0300,$0200,$0200,$0200,$0200
	dc.w	$0100,$0100,$0100
	dcb.w	18,0
	dc.w	$0100,$0100,$0100,$0200,$0200,$0200,$0300,$0300,$0300
	dc.w	$0400,$0400,$0400,$0500,$0500,$0500,$0600,$0600,$0600
	dc.w	$0700,$0700,$0700,$0800,$0800,$0800,$0900,$0900,$0900
	dc.w	$0a00,$0a00,$0a00,$0b00,$0b00,$0b00,$0c00,$0c00,$0c00
	dc.w	$0d00,$0d00,$0d00,$0e00,$0e00,$0e00,$0f00,$0f00,$0f00

	dc.w	$0f00,$0f00,$0f00,$0e00,$0e00,$0e00,$0d00,$0d00,$0d00
	dc.w	$0c00,$0c00,$0c00,$0b00,$0b00,$0b00,$0a00,$0a00,$0a00
	dc.w	$0900,$0900,$0900,$0800,$0800,$0800,$0700,$0700,$0700
	dc.w	$0600,$0600,$0600,$0500,$0500,$0500,$0400,$0400,$0400
	dc.w	$0300,$0300,$0300,$0200,$0200,$0200,$0100,$0100,$0100
	dcb.w	18,0
	dc.w	$0100,$0100,$0100,$0200,$0200,$0200,$0300,$0300,$0300
	dc.w	$0400,$0400,$0400,$0500,$0500,$0500,$0600,$0600,$0600
	dc.w	$0700,$0700,$0700,$0800,$0800,$0800,$0900,$0900,$0900
	dc.w	$0a00,$0a00,$0a00,$0b00,$0b00,$0b00,$0c00,$0c00,$0c00
	dc.w	$0d00,$0d00,$0d00,$0e00,$0e00,$0e00,$0f00,$0f00,$0f00

figuur2:
	dc.w	$00f0,$00f0,$00f0,$00e0,$00e0,$00e0,$00d0,$00d0,$00d0
	dc.w	$00c0,$00c0,$00c0,$00b0,$00b0,$00b0,$00a0,$00a0,$00a0
	dc.w	$0090,$0090,$0090,$0080,$0080,$0080,$0070,$0070,$0070
	dc.w	$0060,$0060,$0060,$0050,$0050,$0050,$0040,$0040,$0040
	dc.w	$0030,$0030,$0030,$0020,$0020,$0020,$0010,$0010,$0010
	dcb.w	36,0
	dc.w	$0010,$0010,$0010,$0020,$0020,$0020,$0030,$0030,$0030
	dc.w	$0040,$0040,$0040,$0050,$0050,$0050,$0060,$0060,$0060
	dc.w	$0070,$0070,$0070,$0080,$0080,$0080,$0090,$0090,$0090
	dc.w	$00a0,$00a0,$00a0,$00b0,$00b0,$00b0,$00c0,$00c0,$00c0
	dc.w	$00d0,$00d0,$00d0,$00e0,$00e0,$00e0,$00f0,$00f0,$00f0

	dc.w	$00f0,$00f0,$00f0,$00e0,$00e0,$00e0,$00d0,$00d0,$00d0
	dc.w	$00c0,$00c0,$00c0,$00b0,$00b0,$00b0,$00a0,$00a0,$00a0
	dc.w	$0090,$0090,$0090,$0080,$0080,$0080,$0070,$0070,$0070
	dc.w	$0060,$0060,$0060,$0050,$0050,$0050,$0040,$0040,$0040
	dc.w	$0030,$0030,$0030,$0020,$0020,$0020,$0010,$0010,$0010
	dcb.w	36,0
	dc.w	$0010,$0010,$0010,$0020,$0020,$0020,$0030,$0030,$0030
	dc.w	$0040,$0040,$0040,$0050,$0050,$0050,$0060,$0060,$0060
	dc.w	$0070,$0070,$0070,$0080,$0080,$0080,$0090,$0090,$0090
	dc.w	$00a0,$00a0,$00a0,$00b0,$00b0,$00b0,$00c0,$00c0,$00c0
	dc.w	$00d0,$00d0,$00d0,$00e0,$00e0,$00e0,$00f0,$00f0,$00f0

	dc.w	$00f0,$00f0,$00f0,$00e0,$00e0,$00e0,$00d0,$00d0,$00d0
	dc.w	$00c0,$00c0,$00c0,$00b0,$00b0,$00b0,$00a0,$00a0,$00a0
	dc.w	$0090,$0090,$0090,$0080,$0080,$0080,$0070,$0070,$0070
	dc.w	$0060,$0060,$0060,$0050,$0050,$0050,$0040,$0040,$0040
	dc.w	$0030,$0030,$0030,$0020,$0020,$0020,$0010,$0010,$0010
	dcb.w	36,0
	dc.w	$0010,$0010,$0010,$0020,$0020,$0020,$0030,$0030,$0030
	dc.w	$0040,$0040,$0040,$0050,$0050,$0050,$0060,$0060,$0060
	dc.w	$0070,$0070,$0070,$0080,$0080,$0080,$0090,$0090,$0090
	dc.w	$00a0,$00a0,$00a0,$00b0,$00b0,$00b0,$00c0,$00c0,$00c0
	dc.w	$00d0,$00d0,$00d0,$00e0,$00e0,$00e0,$00f0,$00f0,$00f0

figuur3:
	dc.w	$000f,$000f,$000f,$000e,$000e,$000e,$000d,$000d,$000d
	dc.w	$000c,$000c,$000c,$000b,$000b,$000b,$000a,$000a,$000a
	dc.w	$0009,$0009,$0009,$0008,$0008,$0008,$0007,$0007,$0007
	dc.w	$0006,$0006,$0006,$0005,$0005,$0005,$0004,$0004,$0004
	dc.w	$0003,$0003,$0003,$0002,$0002,$0002,$0001,$0001,$0001
	dcb.w	18,0
	dc.w	$0001,$0001,$0001,$0002,$0002,$0002,$0003,$0003,$0003
	dc.w	$0004,$0004,$0004,$0005,$0005,$0005,$0006,$0006,$0006
	dc.w	$0007,$0007,$0007,$0008,$0008,$0008,$0009,$0009,$0009
	dc.w	$000a,$000a,$000a,$000b,$000b,$000b,$000c,$000c,$000c
	dc.w	$000d,$000d,$000d,$000e,$000e,$000e,$000f,$000f,$000f

	dc.w	$000f,$000f,$000f,$000e,$000e,$000e,$000d,$000d,$000d
	dc.w	$000c,$000c,$000c,$000b,$000b,$000b,$000a,$000a,$000a
	dc.w	$0009,$0009,$0009,$0008,$0008,$0008,$0007,$0007,$0007
	dc.w	$0006,$0006,$0006,$0005,$0005,$0005,$0004,$0004,$0004
	dc.w	$0003,$0003,$0003,$0002,$0002,$0002,$0001,$0001,$0001
	dcb.w	18,0
	dc.w	$0001,$0001,$0001,$0002,$0002,$0002,$0003,$0003,$0003
	dc.w	$0004,$0004,$0004,$0005,$0005,$0005,$0006,$0006,$0006
	dc.w	$0007,$0007,$0007,$0008,$0008,$0008,$0009,$0009,$0009
	dc.w	$000a,$000a,$000a,$000b,$000b,$000b,$000c,$000c,$000c
	dc.w	$000d,$000d,$000d,$000e,$000e,$000e,$000f,$000f,$000f

	dc.w	$000f,$000f,$000f,$000e,$000e,$000e,$000d,$000d,$000d
	dc.w	$000c,$000c,$000c,$000b,$000b,$000b,$000a,$000a,$000a
	dc.w	$0009,$0009,$0009,$0008,$0008,$0008,$0007,$0007,$0007
	dc.w	$0006,$0006,$0006,$0005,$0005,$0005,$0004,$0004,$0004
	dc.w	$0003,$0003,$0003,$0002,$0002,$0002,$0001,$0001,$0001
	dcb.w	18,0
	dc.w	$0001,$0001,$0001,$0002,$0002,$0002,$0003,$0003,$0003
	dc.w	$0004,$0004,$0004,$0005,$0005,$0005,$0006,$0006,$0006
	dc.w	$0007,$0007,$0007,$0008,$0008,$0008,$0009,$0009,$0009
	dc.w	$000a,$000a,$000a,$000b,$000b,$000b,$000c,$000c,$000c
	dc.w	$000d,$000d,$000d,$000e,$000e,$000e,$000f,$000f,$000f

