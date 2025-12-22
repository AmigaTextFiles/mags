*********** another one **********************

start
	clr.l	d0		;bri¹e D0
	clr.l	d1		;D1
	clr.l	d2		;D2
	clr.l	d3		;D3
	clr.l	d4		;i D4
	lea	text,a0		;adresu "text" upisuje u A0
	lea	textend,a1	;adresu "textend" upisuje u A1
	move.b	(a0),d0		;sa adrese "text" kopira bajt u D0, slovo "s"
	add.l	#1,a0		;uveæava adresu iz A0 za 1
	move.b	(a0),d1		;sa adrese "text+1" kopira bajt u D1, slovo "t"
	sub.l	#1,a1		;umanjuje adresu iz A1 za 1
	move.b	(a1),d4		;sa adrese "textend-1" kopira bajt u D4, "m"
	sub.l	#1,a1		;umanjuje adresu u A1 za 1
	move.b	(a1),d3		;kopira bajt, "r"
	sub.l	#1,a1		;-1
	move.b	(a1),d2		;"o"
	rts			;kraj


text	dc.b	'storm'		;alocira 5 bajtova i puni ih
textend

************************************************