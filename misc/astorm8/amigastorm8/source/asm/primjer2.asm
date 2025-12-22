*************** jo¹ jedan primjer **********

start
	move.l	#$ffffffff,d0	;stavlja $ffffffff u D0
	clr.l	d1		;bri¹e D1
	clr.l	d2		;bri¹e D2
	clr.l	d3		;bri¹e D3
	move.w	d0,d1		;premje¹ta word iz D0 u D1
	move.b	d0,d2		;kopira bajt iz D0 u D2
	rts			;kraj

*********************************************