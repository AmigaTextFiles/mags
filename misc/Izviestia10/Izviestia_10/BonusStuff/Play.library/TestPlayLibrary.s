
*--- play.library ---*
InitPlay	equ	-30
RemPlay		equ	-36

*--- exec.library ---*
OpenLibrary	equ	-552
CloseLibrary	equ	-414



	bsr	OpenPly			; otworz 'play.library'


	lea	ModulAdr(pc),a0		;
	move.l	a0,d0			; w D0 adres wczytanego modulu
	move.l	PlyBase,a6		;
	jsr	InitPlay(a6)		; zacznij grac...

loop	btst	#6,$bfe001		; czekaj na lewy przycisk
	bne	loop			; myszy
	
	move.l	PlyBase,a6
	jsr	RemPlay(a6)		; przerwij odtwarzanie
	
	bsr	ClosPly			; zamknij 'play.library'
	rts



OpenPly	move.l	4.w,a6			; Open play.library
	lea	Plyname(pc),a1
	moveq	#0,d0
	jsr	OpenLibrary(a6)
	move.l	d0,PlyBase
	rts

ClosPly	move.l	4.w,a6			; Close play.library
	move.l	plybase(pc),a1
	jsr	CloseLibrary(a6)
	rts

*----------------------------------------*
PlyBase	dc.l	0
PlyName	dc.b	'play.library',0

	even

; modul musi byc pod parzystym adresem

modul	incbin	'dh0:modules/mod.amegas' 	

