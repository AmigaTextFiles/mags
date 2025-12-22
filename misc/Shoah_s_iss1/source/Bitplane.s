;	  _______  ___                    ___        _______
;	 /°-     \/. /    _____   ____   / ./       /°-     \
;	 \   \___//  \___/°    \_/°   \_/   \___    \   \___/
;	_/\__    \      ~\_  /\  \  /\ ~\      °\_ _/\__    \
;	\\       /   /\   /  \/. /  \/   \ //\   / \\       /
;	 \______/\__/  \_/\_____/\____/\_/_/  \_/ o \______/ Issue 1

;Simple bitplane display
;By Squize	9/12/94

	opt c-				;Always set this !

	Section	Bitplanes,Code		;Always put the code in public mem,
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
	move.l	#Picture,d0		;Set up all the constants
	move.l	d0,d1
	move.l	#10240,d2		;Size of the screen ( Remember ? )
	lea	Bplanes,a0		;Point to the bitplane pointers

	move	d1,4(a0)		;Stuff the lo/hi pointers into the
	swap	d1			;bitplane pointers in the copperlist
	move	d1,(a0)
		addq.l	#8,a0		;Next set of bitplane pointers
		add.l	d2,d0		;Next bitplane
		move.l	d0,d1	
	move	d1,4(a0)		;Keep on doing all this for all 5
	swap	d1			;bitplanes
	move	d1,(a0)
		addq.l	#8,a0
		add.l	d2,d0
		move.l	d0,d1	
	move	d1,4(a0)
	swap	d1
	move	d1,(a0)
		addq.l	#8,a0
		add.l	d2,d0
		move.l	d0,d1	
	move	d1,4(a0)
	swap	d1
	move	d1,(a0)
		addq.l	#8,a0
		add.l	d2,d0
	move	d0,4(a0)
	swap	d0
	move	d0,(a0)

	lea	Picture+51200,a0		;Point to the palette data
	lea	Paper,a1			;Point to the colour regs.
	move	#32-1,d7			;Number of colours
.palette_loop
	move	(a0)+,(a1)			;Slap the colours in there
	addq.l	#4,a1	
	dbra	d7,.palette_loop

	Copper_Set	Copperlist		;This is my macro for turning
						;on the copperlist

	move	#%1000001110000000,$96(a5)	;DMA:Copper/Bitplane on !

	bsr.s	Main				;Now run the main loop

	rts					;All done, so go back to
						;"RestoreSystem"

;*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
;*+*+*+*+*+*+*+*+*+*+*+- The Main Loop -+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
;*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
MAIN:

;*+*+*+	Check for quit

	Mouse_button	Main		;Another macro, if the left mouse
					;button is not pressed then it'll
					;loop to main
	rts				;LMB pressed, so return to "Init"

;*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
;*+*+*+*+*+*+*+*+*+*+*+- Chip-Ram Stuff -+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+

	section	ChipRam,Code_c		;All copperlists/bitplanes/sound/
					;sprites/bobs etc. MUST be in
					;ChipRam !

;*+*+*+*+*+*+*+*+*+*+*+- Copper Lists -+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+

Copperlist:
	dc.w $00e0		;Pointers for bitplane 1
Bplanes	dc.w $0000
	dc.l $00e20000
	dc.l $00e40000		;Pointers for bitplane 2
	dc.l $00e60000
	dc.l $00e80000		;Pointers for bitplane 3
	dc.l $00ea0000
	dc.l $00ec0000		;Pointers for bitplane 4
	dc.l $00ee0000
	dc.l $00f00000		;Pointers for bitplane 5
	dc.l $00f20000

	dc.w $0108,$0000	;Set the modulos
	dc.w $010a,$0000

	dc.l $008e2c81,$00902cc1	;Set the size of the screen
	dc.l $00920038,$009400d0

	dc.w $0102,$0000	;No scrolling

	dc.w $0104,$0000	;Put all the sprites at the back

	dc.w $0180			;The screen colours start
Paper	dc.w $0000			;here...
	dc.l $01820000
	dc.l $01840000
	dc.l $01860000
	dc.l $01880000
	dc.l $018a0000
	dc.l $018c0000
	dc.l $018e0000
	dc.l $01900000
	dc.l $01920000
	dc.l $01940000
	dc.l $01960000
	dc.l $01980000
	dc.l $019a0000
	dc.l $019c0000
	dc.l $019e0000
	dc.l $01a00000
	dc.l $01a20000
	dc.l $01a40000
	dc.l $01a60000
	dc.l $01a80000
	dc.l $01aa0000
	dc.l $01ac0000
	dc.l $01ae0000
	dc.l $01b00000
	dc.l $01b20000
	dc.l $01b40000
	dc.l $01b60000
	dc.l $01b80000
	dc.l $01ba0000
	dc.l $01bc0000
	dc.l $01be0000			;...and end here

		dc.l $3401fffe	;Wait 'til at the top of the screen
	dc.w $0100,$5200	;Turn on 5 bitplanes, ie 32 colour screen

		dc.l $fffffffe	;End the copperlist
		dc.l $fffffffe

;*+*+*+*+*+*+*+*+*+*+*+- Data -+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+
Picture:
	incbin	SHOAH.s:data/picture.raw
	even