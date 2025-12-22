****** This program's (this section and all modules on disk) source code is
******       Copyright © 1987,1988 by Jamie D. Purdon  (Cleveland, Ohio)
** 1> HeyLine DigiPaint count#rgb line# r# g# b#  (r,g,b range 0..1023)
** causes digipaint to fill line# with count#rgb pixels of r#,g#,b# color
*
*** builds 
* msg	{
*		standard msg node
*		'REMO'
*		'Dlvb',Count.W,Line.W,n(rgb) 'remainder of cmdline'
*	}

	section	Startup,CODE

	include "exec/types.i"
	include "exec/nodes.i"
	include "exec/lists.i"
	include "exec/ports.i"
	;include "exec/tasks.i"
	include "exec/execbase.i"
	include "libraries/dosextens.i"	; for pr_... process struct
	include "exec/memory.i" ;for AllocMem types
	;include "exec/funcdef.i" 
	include "libraries/dos.i" 


 STRUCTURE MyVariables,0 ;<<=THIS IS WHERE WE POINT A5 (BP) ....
 LONG CmdLineLen_ original, from dos or zero
 LONG CmdLineAdr_ original, from dos or modified -> icon name
 LONG HisPort_	;digipaint's paint, which we look for...
 STRUCT DigiPortName_,40	;name of port to send msg to
 STRUCT OnlyPort_,MP_SIZE	;standard exec message port
; STRUCT CustMsg_,128		;lotsa room, msgs are small anyway
 STRUCT CustMsg_,(128+(6*1024))		;LOTSA room,...wholeline of max#rgb's
 LABEL BP_SIZEOF	;size of scratch / bss section / variables

BP equr A5
CALLIB macro
  ifnd _LVO\1
	xref	_LVO\1
  endc
	jsr	_LVO\1(a6)
	endm

******************** Start of Code *************************

;Allocate a 'basepage' and point A5 to it
start:	move.l	$0004,a6		;we only need exec calls!
	movem.l	d0/a0,-(sp)		;cmdline args if any
	move.l	#((BP_SIZEOF+7)&$ffffFFF8),d0	;basepage size, roundup 2xlword
	move.l	#MEMF_PUBLIC!MEMF_CLEAR,d1	;pub for msg=shared mem
	CALLIB	AllocMem
	tst.l	d0			;set/clr zero flag
	move.l	d0,BP			;register A5, basepage, vars at +offsets
	movem.l	(sp)+,d0/a0		;cmdline args if any (moveM no Z effect)
	beq	nomem_atall		;abort!, no base avail!

;Ensure CLI-type startup (any shell should work)
	movem.l d0/a0,CmdLineLen_(BP)
	move.l	ThisTask(a6),A4		;execbase, us, we're alive, right?
	tst.l	pr_CLI(A4)		;A4=OUR TASK do we have a cli struct?
	beq	Boom			;boom. (from wbench?), CLI ONLY!!!

;Grab portname from cmd line
	lea	DigiPortName_(BP),a1	;a0=cmdline ptr
grabname:
	move.b	(a0)+,d1	;char from cmdline
	beq.s	endname
	cmp.b	#$0a,d1
	beq.s	endname
	cmp.b	#' ',d1
	beq.s	endname
	move.b	d1,(a1)+	;...to string at end of custmsg
	subq	#1,d0
	bne.s	grabname
endname:		;string 'digiportname' on basepage, a0=resta cmd line
	clr.b	(a1)	;NULL to end 'digiportname'

;Copy rest of cmd line to custom message
	lea	CustMsg_(BP),a1	;A1=msgptr
	move.b	#NT_MESSAGE,LN_TYPE(a1)	;fill in (alloc'd clear) msg struct
	lea	OnlyPort_(BP),a2
	move.l	a2,MN_REPLYPORT(a1)	;point back to our port for reply

	lea	MN_SIZE(a1),a2	;a2=ptr end of message
	move.l	a2,LN_NAME(a1)	;name of 'our' msg...
	move.l	#'REMO',(a2)+	;gonna builda name



 IFC 't','f'
	subq	#1,d0	;d0=db' type loop ctr, LEN of remainder of cmd line
grabcl:	move.b	(a0)+,d1	;char from cmd line
	beq.s	endmsg
	cmp.b	#$0a,d1		;eol?
	beq.s	endmsg
	move.b	d1,(a2)+
	dbf	d0,grabcl
endmsg:			;string 'digiportname' on basepage
  ENDC
	

	move.l	#'Dlvb',(a2)+	;'DeLiVer Binary action code'
	;move.W	#96,(a2)+	;COUNT (deliver this many)
	bsr	cva2i
	move.w	d0,(a2)+	;COUNT from cmd line WATCH NO ERROR CHECKING
	;move.w	#10,(a2)+	;line# on digipaint screen
	bsr	cva2i
	move.w	d0,(a2)+	;line# from cmd line WATCH NO ERROR CHECKING

	;ConVertAscii2Integer:
	;-skips digits after decimal point
	;-no negative #s, result must be WORD size....64k-1

	;a0=point to string, returns d0=#, a0 advanced just past # (DESTROYS D1)
	bsr cva2i
	move.w	d0,-(sp)	;RED
	bsr cva2i
	move.w	d0,-(sp)	;GREEN
	bsr cva2i

	move.w	#$03ff,d3	;max blue
	move.w	d3,d2	;max gr
	move.w	d3,d1	;max red

	and.w	d0,d3		;BLUE
	and.w	(sp)+,d2	;GREEN
	and.w	(sp)+,d1	;RED

	
	move.w	-4(a2),d0	;count, from cmd line (pull frm blding msg)
	subq	#1,d0		;dbf' type loop
packit:	move.w	d1,(a2)+	;red
	move.w	d2,(a2)+	;gr
	move.w	d3,(a2)+	;blue
	dbf	d0,packit



	lea	DigiPortName_(BP),a1
	CALLIB	FindPort
	move.l	d0,HisPort_(BP)	;digipaint's msg port
	beq	Boom

;Make a port named "REMOblahblah" ANNOUNCE OURSELVES
	LEA	OnlyPort_(BP),a2	;A2=PORT
	moveq	#-1,d0
	CALLIB	AllocSignal	;d0=return
	moveq	#-1,d1
	cmp.l	d0,d1	;-1 indicates bad signal
	beq	Boom
	move.b	d0,MP_SIGBIT(a2)
	move.b	#PA_SIGNAL,MP_FLAGS(a2)
	move.b	#NT_MSGPORT,LN_TYPE(a2)
	clr.b	LN_PRI(a2)
	move.l	A4,MP_SIGTASK(a2)	;task cached at start....

	lea	MP_MSGLIST(a2),a0	;new port's list header
	NEWLIST	a0			;use macro from exec/lists.i

	lea	CustMsg_(BP),a1		;A1=msgptr
	lea	MN_SIZE(a1),a1	;stringptr 'REMO'blahblah
	move.l	a1,LN_NAME(a2)		;portname=

	move.l	a2,a1			;A2=A1=PORT
	CALLIB	AddPort to the system list, let everyone see I'm here...

;Send CustMsg to HisPort
	move.l	HisPort_(BP),a0	;DigiPaint's port
	lea	CustMsg_(BP),a1
	CALLIB	PutMsg			;send msg to digipaint

waitonm:
	lea	OnlyPort_(BP),a0
	CALLIB	WaitPort
	lea	OnlyPort_(BP),a0
	CALLIB	GetMsg
	tst.l	d0		;we got a signal, did we get a mesg?
	beq.s	waitonm
	move.l	d0,a1		;msgptr in a1 for ReplyMsg call
	;lea	CustMsg_(BP),a2	;our msg, did it come back?
	;cmp.l	a1,a2
	cmp.b	#NT_REPLYMSG,LN_TYPE(a1) ;=NT_REPLYMSG (back from digipaint?)
	beq.s	endsig
	CALLIB	ReplyMsg	;be polite and reply all unknown msgs
	bra.s	waitonm
endsig:		;got a 'reply' back from digipaint to 'our' msg

	lea	OnlyPort_(BP),a1
	CALLIB	RemPort

	lea	OnlyPort_(BP),a1
	moveq	#0,d0	;Clear upper 3/4 of d0
	move.b	MP_SIGBIT(a1),d0
	beq.s	9$
	CALLIB	FreeSignal
9$
Boom:
	move.l	BP,a1
	move.l	#((BP_SIZEOF+7)&$ffffFFF8),d0	;basepage size, roundup 2xlword
	CALLIB	FreeMem

	moveq	#0,d0	;error code?
	rts	;th-th-th-that's all folks

nomem_atall:
	moveq	#103,d0	;nomem?
	rts








	;ConVertAscii2Integer:
	;-skips digits after decimal point
	;-no negative #s, result must be WORD size....64k-1

cva2i:	;a0=point to string, returns d0=#, a0 advanced just past # (DESTROYS D1)
	;"suitably" commented out to 1) NOT ALLOW NEGATIVE, 2) MAX=64K-1(?)
	move.l	d3,-(sp)
	moveq	#0,d0		;start with zero
	moveq	#0,d1		;clear upper bytes
	moveq	#10,d3		;assume BASE 10

cva_findstart:
	move.b	(a0)+,d1	;get characters from start
	beq	bodyDone
	cmp.b	#$0a,d1
	beq	err_cvaout
	cmp.b	#'.',d1		;DOT endzittoo
	beq	skipfrac	;bodyDone	;boom
	; cmpi.b	#'0',d1
	; beq.s	cva_findstart	;chuck initial zeros
	cmpi.b	#' ',d1
	beq.s	cva_findstart	;chuck initial blanks
	cmpi.b	#'x',d1		;check for hex forms
	beq.s	initialHex
	cmpi.b	#'$',d1	
	beq.s	initialHex
	bra.s	cva_ck1st
initialHex:
	move.w	#16,d3		;show base of 16, preserving minus

bodyStr:
	move.b	(a0)+,d1	;get next character
bodyConvert:
	beq	bodyDone	;null @ end of string?
	cmp.b	#' ',d1		;blank endzittoo
	beq	bodyDone
	cmp.b	#'/',d1		;slash is a delimiter, too
	beq	bodyDone
	cmp.b	#'.',d1		;DOT endzittoo
	beq.s	skipfrac	;bodyDone
cva_ck1st:
	cmp.b	#$0d,d1		;cr?
	beq	bodyDone
	cmp.b	#$0a,d1		;lf?
	beq.s	bodyDone
	cmp.b	#$09,d1		;tab?
	beq.s	bodyDone
				;prob'ly have a valid digit, shift accum
	mulu	d3,d0		;result=result*base
	cmpi.b	#'0',d1
	blt.s	badChar
	cmpi.b	#'9',d1
	bgt.s	perhapsHex
	subi.b	#'0',d1
	add.W	d1,d0		;binary value now, accum.
	bra.s	bodyStr		;go get another char

perhapsHex:
	cmp.w	#16,d3		;working in hex (base 16) now?
	bne.s	badChar
	cmpi.b	#'A',d1
	blt.s	badChar
	cmpi.b	#'F',d1
	bgt.s	perhapsLCHex
	subi.b	#'A'-10,d1
	add.w	d1,d0
	bra.s	bodyStr

perhapsLCHex:
	cmpi.b	#'a',d1
	blt.s	badChar
	cmpi.b	#'f',d1
	bgt.s	badChar
	subi.b	#'a'-10,d1
	add.w	d1,d0		;binary, accum.
	bra.s	bodyStr

badChar:
	tst.l	d0		;if we already have a #...
	bne.s	enda_cva2i	;... end on non-# char
err_cvaout:
	moveq	#-1,d0		;else flag error as minus
	bra.s	enda_cva2i
skipfrac:		;done scanning, found a 'dot'...skip fract digits
	move.b	(a0)+,d1
	beq.s	bodyDone	;null @ end of string?
	cmp.b	#' ',d1		;blank endzittoo
	beq.s	bodyDone
	cmp.b	#'.',d1		;DOT endzittoo
	beq.s	skipfrac	;bodyDone
	cmp.b	#$0d,d1		;cr?
	beq.s	bodyDone
	cmp.b	#$0a,d1		;lf?
	beq.s	bodyDone
	cmp.b	#$09,d1		;tab?
	beq.s	bodyDone
	cmp.b	#'/',d1		;slash ok too
	;beq.s	bodyDone
	bne.s	skipfrac
bodyDone:
enda_cva2i:
	move.l	(sp)+,d3
	tst.l	d0	;be nice, test for minus after subr call for errchk
	rts	;cva2i

  END