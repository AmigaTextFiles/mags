;	  _______  ___                    ___        _______
;	 /°-     \/. /    _____   ____   / ./       /°-     \
;	 \   \___//  \___/°    \_/°   \_/   \___    \   \___/
;	_/\__    \      ~\_  /\  \  /\ ~\      °\_ _/\__    \
;	\\       /   /\   /  \/. /  \/   \ //\   / \\       /
;	 \______/\__/  \_/\_____/\____/\_/_/  \_/ o \______/ Issue 1

;Simple copper Display
;By Squize	9/12/94

	opt c-				;Always set this !

	Section	Copper,Code		;Always put the code in public mem,
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

	move	#%1000001010000000,$96(a5)	;DMA:Copper on !

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

	dc.w $0180,$0111		;Set the first paper colour
		dc.l $8001fffe		;First wait
	dc.w $0180,$0222
		dc.l $8101fffe
	dc.w $0180,$0333
		dc.l $8201fffe
	dc.w $0180,$0444
		dc.l $8301fffe
	dc.w $0180,$0555
		dc.l $8401fffe
	dc.w $0180,$0666
		dc.l $8501fffe
	dc.w $0180,$0777
		dc.l $8601fffe
	dc.w $0180,$0888
		dc.l $8701fffe
	dc.w $0180,$0999
		dc.l $8801fffe
	dc.w $0180,$0aaa
		dc.l $8901fffe
	dc.w $0180,$0bbb
		dc.l $8a01fffe
	dc.w $0180,$0ccc
		dc.l $8b01fffe
	dc.w $0180,$0ddd
		dc.l $8c01fffe
	dc.w $0180,$0eee
		dc.l $8d01fffe
	dc.w $0180,$0fff
		dc.l $8e01fffe
	dc.w $0180,$0eee
		dc.l $8f01fffe
	dc.w $0180,$0ddd
		dc.l $9001fffe
	dc.w $0180,$0ccc
		dc.l $9101fffe
	dc.w $0180,$0bbb
		dc.l $9201fffe
	dc.w $0180,$0aaa
		dc.l $9301fffe
	dc.w $0180,$0999
		dc.l $9401fffe
	dc.w $0180,$0888
		dc.l $9501fffe
	dc.w $0180,$0777
		dc.l $9601fffe
	dc.w $0180,$0666
		dc.l $9701fffe
	dc.w $0180,$0555
		dc.l $9801fffe
	dc.w $0180,$0444
		dc.l $9901fffe
	dc.w $0180,$0333
		dc.l $9a01fffe
	dc.w $0180,$0222
		dc.l $9b01fffe
	dc.w $0180,$0111
		dc.l $9c01fffe
	dc.w $0180,$0000			;phew...

	dc.l $fffffffe
	dc.l $fffffffe

