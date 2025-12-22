***********************************

final_test
	lea	boje,a0		;stavlja adresu tabele sa bojama u a0
	move	#8,d1		;stavlja 8 u d1
.l1	move	(a0,d1.w*2),d0	;u d0 kopira word sa adrese iz a0+d1*2
	jsr	color		;skaèe na rutinu za postavljanje boje
	sub	#1,d1		;oduzima 1 od d1
	cmp	#-1,d1		;ukoliko je -1 u d1
	beq	kraj		;skaèe na labelu kraj
	nop			;ukoliko nije -1
	nop			;3 puta ne radi ni¹ta =) tj. èeka 6. ciklusa
	nop			;(nikad nemojte praviti ovakvo èekanje jer nisu
				;svi procesori jednako brzi, ovo je samo primjer)
	jmp	.l1		;skaèe na .l1 (labela sa taèkom ispred je interna
				;labela)
kraj	rts


color
	lea	$dff000,a6	;stavlja adresu $dff000 u a6
	move.l	#$fffff,d7	;$fffff na d7
.l1	move.w	d0,$180(a6)	;boju iz d0 na $dff180 (boja pozadine)
	move.w	d0,$182(a6)	;d0 na $dff182 (1. boja)
	move.w	d0,$184(a6)	;$dff184...	
	move.w	d0,$186(a6)	;....
	sub.l	#1,d7		;oduzima #1 od d7
	cmp.l	#0,d7		;da li je 0 u d7?
	bne	.l1		;Ne, onda skok na .l1 (kao ¹to vidite ista labela
				;se pojavljuje i ovde, ali ona pripada color rutini
				;Izmeðu dve globalne labele (final_test,kraj,color..)
				;moze da se nalazi vi¹e internih koje na koje mozete
				;skakati samo izmeðu te dve globalne.
	rts			;Ako je 0 u d7, povratak iz rutine

boje
	dc.w	$f00		;boje su zapisane u RGB formatu, bajt za svaku
	dc.w	$0f0		;komponentu
	dc.w	$00f		
	dc.w	$000
	dc.w	$fff
	dc.w	$0ff
	dc.w	$f0f
	dc.w	$ff0		
	
*************************************