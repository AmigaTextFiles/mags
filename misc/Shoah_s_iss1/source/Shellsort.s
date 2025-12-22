;	  _______  ___                    ___        _______
;	 /°-     \/. /    _____   ____   / ./       /°-     \
;	 \   \___//  \___/°    \_/°   \_/   \___    \   \___/
;	_/\__    \      ~\_  /\  \  /\ ~\      °\_ _/\__    \
;	\\       /   /\   /  \/. /  \/   \ //\   / \\       /
;	 \______/\__/  \_/\_____/\____/\_/_/  \_/ o \______/ Issue 1

;i used asmone and trashemone
;*****************************************************************************
;exec.library
allocmem	equ	-198
freemem		equ	-210
oldopenlibrary	equ	-408
closelibrary	equ	-414

;dos.library
open		equ	-30
close		equ	-36
read		equ	-42
write		equ	-48
output		equ	-60
lock		equ	-84
unlock		equ	-90
examine		equ	-102


	movem.l	d1-d7/a1-a6,-(a7)	;store regs
;-------------
	move.l	$4.w,a6
	movem.l	d0/a0,-(a7)		;store temporary
	lea	doslib,a1
	jsr	oldopenlibrary(a6)
	move.l	d0,a5
	movem.l	(a7)+,d0/a0		;regs back
	move.l	a5,dosbase		;store dos base

	cmp.l	#1,d0			;if there is no input from CLI
	beq.w	kraj			;go to end
	cmp.b	#$3f,(a0)		;is first character '?'
	beq.w	kraj
	
	move.l	a0,a2			;store address of CLI input 
	lea	buff,a1
	bsr.w	string			;read one text word
	cmp.b	#"-",(a1)
	bne.b	nista
	move.b	#$ff,flag		;set only flag for option '-n'
	bra.b	nesta
nista	move.b	#0,flag			;reset flag
	move.l	a2,a0			;no options, bring back
nesta	lea	ulaz,a1
	bsr.w	string			;read input file name
	lea	izlaz,a1
	bsr.w	string			;read output file name
;***********************************************************************
	jsr	output(a5)		;take handle pointer
	move.l	d0,d1
	move.l	#reading,d2
	moveq	#$0b,d3
	jsr	write(a5)		;write text "reading..."

	move.l	#$108,d0		;264 bytes for FileInfoBlock
	moveq	#00,d1
	jsr	allocmem(a6)
	move.l	d0,a4			;store temporary

	move.l	#ulaz,d1
	move.l	#-2,d2			;shared lock
	jsr	lock(a5)		;lock

	tst.l	d0
	beq.w	error1

	move.l	d0,-(a7)		;store pointer
	move.l	d0,d1			;lock pointer
	move.l	a4,d2			;FileInfoBlock allocation
	jsr	examine(a5)		;examine file

	tst.l	d0
	beq.w	error1
	move.l	$7c(a4),size		;store file length

	move.l	#$108,d0
	move.l	a4,a1
	jsr	freemem(a6)		;free 264 bytes

	move.l	(a7)+,d1		;take back lock pointer
	jsr	unlock(a5)		;unlock
;-------------
	move.l	size,d0
	moveq	#00,d1
	jsr	allocmem(a6)		;alocate place for input file

	move.l	d0,a4			;store pointer
	move.l	d0,source
	move.l	size,d0
	moveq	#00,d1
	jsr	allocmem(a6)		;alocate place for sorted file

	move.l	d0,dest			;store pointer
;-------------
	move.l	#ulaz,d1
	move.l	#1005,d2
	jsr	open(a5)		;open input file

	tst.l	d0
	beq.w	error1			;on error, finish
	move.l	d0,-(a7)		;store file pointer

	move.l	d0,d1
	move.l	a4,d2
	move.l	size,d3
	jsr	read(a5)		;read input file

	tst.l	d0
	beq.w	error1
	move.l	d0,length		;store number of bytes readed

	move.l	(a7)+,d1		;take back file pointer
	jsr	close(a5)		;close input file
;*************************************************************************
	clr.l	d5			;lines counter
	tst.b	flag			;do we have option '-n'
	bne.b	bb

	move.l	length,d0		;read file length
	moveq	#10,d3			;LINE FEED
	bra.b	ba

ba0	addq.l	#1,d5			;lines counter++
ba 	subq.l	#1,d0			;char counter--
	tst.l	d0
	bmi.b	otislo			;have we read all chars
	cmp.b	(a4)+,d3		;is char LINE FEED
	bne.b	ba			;jump if not LF

	bra.b	ba0
;-------------
bb	move.l	length,d0		;read file length
	moveq	#0,d2			;clear counter (no. of chars in line)
	moveq	#$0a,d3			;LINE FEED
	moveq	#$20,d1			;SPACE
	moveq	#01,d7
	bra.b	b21

b11	subq.l	#1,d0			;char counter--
	addq.l	#1,a4			;address++
	tst.l	d0			;is it end of file
	bmi.b	otislo			;if it is, go further

b21	cmp.b	(a4),d1			;is char less than SPACE
	bge.b	b11			;it is, jump (SPACE is > than char)

bc 	subq.l	#1,d0			;char counter--
	tst.l	d0
	bmi.b	otislo
	addq.b	#1,d2			;chars in line counter++
	cmp.b	(a4)+,d3		;is it LINE FEED(end of line)
	bne.b	bc			;jump if not LF

	cmp.b	d7,d2			;is line length 1 (only LF)
	beq.b	bd			;if it is, ignore it
	addq.l	#1,d5			;lines counter++
bd	moveq	#0,d2			;clear counter
	bra.b	b21
;-------------
otislo	move.l	d5,no_of_lines		;store it
	
	move.l	d5,d0			;no. of lines
	lsl.l	#2,d0			;divide by 4
	addq.l	#4,d0			;add 4 bytes
	move.l	d0,size2
	moveq	#00,d1
	jsr	allocmem(a6)		;alocate place for pointers on
					;beginning of line
	move.l	d0,a3			;store pointer
	move.l	d0,pointers1
	move.l	source,a4
	
	tst.b	flag			;check option
	bne.b	aa
	move.l	a4,(a3)+		;first pointer is pointer on
					;   first char in file 
aa	move.l	no_of_lines,d0
	moveq	#00,d1			;alocate place for lenghts
	jsr	allocmem(a6)		;of lines

	move.l	d0,pointers2
;-------------
	tst.b	flag			;test flag
	bne.w	read2

	move.l	length,d0		;take file length
	move.l	pointers2,a2		;place for line pointers
	moveq	#10,d3			;LINE FEED
	moveq	#0,d2			;clear
	bra.b	nije

ni	move.b	d2,(a2)+		;store no of chars in line
	move.l	a4,(a3)+		;store next address as pointer
	moveq	#0,d2			;clear counter

nije 	subq.l	#1,d0			;char counter--
	tst.l	d0			;is it all ?
	bmi.b	nema			;if yes, finish this part
	addq.b	#1,d2			;chars in line counter++
	cmp.b	(a4)+,d3		;is it LINE FEED
	bne.b	nije			;jump if not LF

	bra.b	ni
;-------------
read2	move.l	length,d0		;take file length
	move.l	d0,d5
	move.l	pointers2,a2		;place for line pointers
	moveq	#0,d2			;clear counter
	moveq	#10,d3			;LINE FEED
	moveq	#32,d1			;SPACE
	moveq	#01,d7
	bra.b	b2

era	moveq	#0,d2			;clear counter
	subq.l	#1,d5			;char counter--
	bra.b	b2
		
b1	subq.l	#1,d0			;char counter--
	tst.l	d0
	bmi.b	nema2			;is it EOF (jump if is)
	addq.l	#1,a4			;address++
	subq.l	#1,d5			;char counter--

b2	cmp.b	(a4),d1			;is it less than SPACE
	bge.b	b1			;SPACE is greater, jump

	move.l	a4,a0			;store address of line

nije2 	subq.l	#1,d0			;char counter--
	tst.l	d0
	bmi.b	nema2			;is it EOF
	addq.b	#1,d2			;chars in line counter++
	cmp.b	(a4)+,d3		;is it LINE FEED (end of line)
	bne.b	nije2			;jump if not LF

	cmp.b	d7,d2			;is line length 1,only LF
	beq.b	era			;if is, ignore it
	move.b	d2,(a2)+		;store no. of chars
	move.l	a0,(a3)+		;store next address as pointer
	moveq	#0,d2			;clear counter
	bra.b	b2
nema2	move.l	d5,length		;store new length of file without
					;chars that are ignored
;**********************************************************************
nema	jsr	output(a5)
	move.l	d0,d1
	move.l	#sorting,d2
	moveq	#$0f,d3
	jsr	write(a5)		;write text "sorting..."

	move.l	no_of_lines,a4		;read no. of lines
	move.l	a4,d0
		
	move.l	pointers1,a0		;read address of pointers to source
	move.l	pointers2,a3		;read address where to put sorted pointers

	bra.b	a

;d0=range, d1=i, d2=j, a4=n
;this variables are same as in algorithm i wrote at start of file
zamjena	move.l	d4,a1			;get addresses of
	move.l	d5,a2			;both operands
	move.l	(a2),d4
	move.l	(a1),(a2)		;first pointer instead second
	move.l	d4,(a1)			;second pointer instead first

	move.l	d6,a1			;read address of 1st operand
	move.l	d7,a2			;read address of 2nd operand
	move.b	(a2),d4			;swap no. of chars in lines
	move.b	(a1),(a2)		;for same lines as above
	move.b	d4,(a1)
	bra.b	dalje

a	lsr.l	#1,d0			;range divide by 2
	beq.b	gotovo			;if x==0, finish sort

	move.l	d0,d1			;i=range
	subq.l	#1,d1			

b	addq.l	#1,d1			;i++
	cmp.l	a4,d1			;is i==n
	beq.b	a			;if it is, jump

	move.l	d1,d2			;j=i
dalje	sub.l	d0,d2			;j=i-range
	bmi.b	b			;if j<0, jump

	move.l	a3,d6			;read addresses of lengths
	add.l	d2,d6			;   of lines
	move.l	a3,d7			;for both operands
	add.l	d2,d7
	add.l	d0,d7

	asl.l	#2,d2			;d2=d2*4; for longs
	asl.l	#2,d0			;d0      -||-
	move.l	a0,a1			;a1=j-th element
	add.l	d2,a1
	move.l	a0,a2			;a2=(j+range)-th element
	add.l	d2,a2
	add.l	d0,a2
	move.l	a1,d4			;store 1st pointer
	move.l	a2,d5			;store 2nd pointer
	move.l	(a1),a1			;store 1st operand address
	move.l	(a2),a2			;store 2nd operand address
	asr.l	#2,d2			;d2=d2/4
	asr.l	#2,d0			;d0=d0/4
	
ponovo	cmpm.b	(a1)+,(a2)+		;compare two chars
	bmi.b	zamjena			;if 2nd<1st, change them
	beq.b	ponovo			;if 1st==2nd, check next
	bra.b	b			;if 1st<2nd, compare next two lines
;***********************************************************************
gotovo	jsr	output(a5)
	move.l	d0,d1
	move.l	#writing,d2
	moveq	#$0f,d3
	jsr	write(a5)		;write text "writing..."

	move.l	pointers1,a3		;read start of sorted pointers
	move.l	dest,a2			;read destination address
	move.l	pointers2,a0		;read addr. of length of lines
	move.l	no_of_lines,d2		;read no. of lines

	move.b	#$fc,d1			;mask for savingfirst 6 bits,
					;to find no. of longs in line
	moveq	#3,d3			;3 bytes and  mask %00000011
	moveq	#10,d4			;LINE FEED	

jos	tst.l	d2			;is lines counter==0
	beq.b	next			;yes, finish this part
	move.l	(a3)+,a1		;move pointer of actual line
	subq.l	#1,d2			;lines counter--
	move.b	(a0)+,d0		;length of line in bytes
	cmp.b	d3,d0			;compare with 3
	ble.b	x			;if length <= 3, jump

long	move.b	d0,d6			;store 
	and.b	d1,d0			;clear no. of chars with mask %11111100
	lsr.b	#2,d0			;and eliminate 2 last right bits

jos2	move.l	(a1)+,(a2)+		;copy necessary no. of longs
	subq.b	#1,d0			;no. of longs--
	bne.b	jos2			;loop
	
	and.b	d3,d6			;store 2 right bits
	beq.b	jos			;if there is no chars, continue

x	move.b	(a1),(a2)+		;copy char
	move.b	(a1)+,d6		;read next char
	cmp.b	d4,d6			;is it LINE FEED,
	bne.b	x			;no, copy more chars
	bra.b	jos			;yes, continue

;***********************************************************************
next	move.l	#izlaz,d1
	move.l	#1006,d2
	jsr	open(a5)		;open output file
	tst.l	d0
	beq.w	error2			;output file error
;-------------
	move.l	d0,d1			;file pointer
	move.l	d0,-(a7)		;store
	move.l	dest,d2			;address
	move.l	length,d3		;file length
	jsr	write(a5)		;write output file
;-------------
	move.l	(a7)+,d1
	jsr	close(a5)		;close output file
;-------------
	jsr	output(a5)
	move.l	d0,d1
	move.l	#done,d2		;write last message
	moveq	#$10,d3
	jsr	write(a5)
	
dealloc	move.l	size,d0
	move.l	source,a1
	jsr	freemem(a6)		;free 1st memory
;-------------
	move.l	size,d0
	move.l	dest,a1
	jsr	freemem(a6)		;free 2nd memory
;-------------
	move.l	size2,d0
	move.l	pointers1,a1
	jsr	freemem(a6)		;free place for pointers
;-------------
	move.l	no_of_lines,d0
	move.l	pointers2,a1		;free place for line lengths
	jsr	freemem(a6)
;-------------
kraj2	move.l	a5,a1
	jsr	closelibrary(a6)	;close dos.library
	movem.l	(a7)+,d1-d7/a1-a6
	rts
;***********************************************************************
kraj	bsr.b	ekran			;pointer in d1
	move.l	#logo,d2
	move.l	#$ee,d3
	jsr	write(a5)		;write text message

	jmp	kraj2

error1	bsr.b	ekran
	move.l	#greska1,d2
	moveq	#22,d3
	jsr	write(a5)		;write text input error

	jmp	dealloc

error2	bsr.b	ekran
	move.l	#greska2,d2
	moveq	#22,d3
	jsr	write(a5)		;write text output error

	jmp	dealloc


ekran	jsr	output(a5)
	tst.l	d0
	beq.b	.ekr2
	move.l	d0,d1
	rts

.ekr2	move.l	(a7)+,d0		;return address pick from stack
	jmp	dealloc

string	movem.l	d1-d3/a1,-(a7)		;store regs

	moveq	#10,d1			;LINE FEED
	moveq	#32,d2			;SPACE
	clr.l	d0			;clear counter
.a	move.b	(a0),d3
	cmp.b	d2,d3			;is it SPACE
	beq.s	.bb
	cmp.b	d1,d3			;is it LINE FEED
	beq.b	.c
	tst.l	d3			;is it NULL
	beq.b	.c
	move.b	(a0)+,(a1)+		;copy char
	addq.l	#1,d0			;counter++
	bra.b	.a
.bb	addq.l	#1,a0			;address++
	cmp.b	(a0),d2			;is it another SPACE
	beq.b	.bb			;if not, stay here
.c	clr.b	(a1)			;put NULL at the end of string
	addq.l	#1,d0			;counter++
	movem.l	(a7)+,d1-d3/a1		;bring back regs
	rts

;------------------------------------------------------------------------------	
doslib	dc.b	"dos.library",0
ulaz	ds.b	40
izlaz	ds.b	40
buff	ds.b	40
logo	dc.b	10,"Shellsort V1.12 ",10				;18
	dc.b	"   Made by ONE MAN GANG",10				;24
	dc.b	"Herendic Drazen",10					;16
	dc.b	"26. lipanj 9",10,"43240 CAZMA",10,"CROATIA",10,10	;34
	dc.b	"USAGE: Shellsort [-n] input_file output_file ",10	;46
	dc.b	"  -n leading spaces and control characters are ignored",10,0 ;56
	dc.b	"     (tabs, line feeds, form feeds, etc.)",10,10,0	;44
;		 1---5----0----5----0----5----0----5----0----5----0
reading	dc.b	"Reading...",0,0
sorting	dc.b	$9b,$31,$30,$44,"Sorting...",0,0
writing	dc.b	$9b,$31,$30,$44,"Writing...",0,0
done	dc.b	$9b,$31,$30,$44,"Done !    ",10,0
greska1	dc.b	10,"Input file error ! ",10,0
greska2	dc.b	10,"Output file error !",10,0
dosbase	dc.l	0
length	dc.l	0		;length of file
source	dc.l	0		;address where file is loaded
dest	dc.l	0		;address where sorted file is stored
pointers1	dc.l	0	;array of pointers to start of line
pointers2	dc.l	0	;array of pointers on lengths of lines
no_of_lines	dc.l	0	;no. of lines=no. of pointers
flag	dc.b	0,0		;for option '-n'
size	dc.l	0
size2	dc.l	0
