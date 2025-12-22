*********** amigastorm! *********************

start				;labela
	move.l	#$10,d0		;stavlja $10 u D0
	move.l	#$20,d1		;stavlja $20 u D1
	add.l	d0,d1		;zbraja sadr¾aj D0 sa D1, rezultat ide u D1
	rts			;izlazi iz programa

*********************************************