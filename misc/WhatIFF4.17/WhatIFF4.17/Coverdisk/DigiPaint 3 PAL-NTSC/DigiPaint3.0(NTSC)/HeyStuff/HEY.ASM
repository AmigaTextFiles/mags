****** This program's (this section and all modules on disk) source code is
******       Copyright © 1987,1988 by Jamie D. Purdon  (Cleveland, Ohio)
*** builds
* msg	{
*		standard msg node
*		'REMO'
*		'remainder of cmdline'
*	}
*** sends msg to port named on cmdline
*** cmdline:  1> hey hp Quit
*		     +- ---+
*		     |     msg
*		     +port

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
 LONG HostPort_			;HostPort, which we look for...
 STRUCT HostPortName_,40	;name of port to send msg to
 STRUCT OnlyPort_,MP_SIZE	;standard exec message port
 STRUCT CustMsg_,128		;lotsa room, msgs are small anyway
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
	lea	HostPortName_(BP),a1	;a0=cmdline ptr
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
endname:		;string 'HostPortName' on basepage, a0=resta cmd line
	clr.b	(a1)	;NULL to end 'HostPortName'

;Copy rest of cmd line to custom message
	lea	CustMsg_(BP),a1	;A1=msgptr
	move.b	#NT_MESSAGE,LN_TYPE(a1)	;fill in (alloc'd clear) msg struct
	lea	OnlyPort_(BP),a2
	move.l	a2,MN_REPLYPORT(a1)	;point back to our port for reply

	lea	MN_SIZE(a1),a2	;a2=ptr end of message
	move.l	a2,LN_NAME(a1)	;name of 'our' msg...
	move.l	#'REMO',(a2)+	;gonna builda name

	subq	#1,d0	;d0=db' type loop ctr, LEN of remainder of cmd line
grabcl:	move.b	(a0)+,d1	;char from cmd line
	beq.s	endmsg
	cmp.b	#$0a,d1		;eol?
	beq.s	endmsg
	move.b	d1,(a2)+
	dbf	d0,grabcl
endmsg:			;string 'HostPortName' on basepage

	lea	HostPortName_(BP),a1
	CALLIB	FindPort
	move.l	d0,HostPort_(BP)	;HostPort's msg port
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

;Send CustMsg to HostPort
	move.l	HostPort_(BP),a0	;HostPort's port
	lea	CustMsg_(BP),a1
	CALLIB	PutMsg			;send msg to HostPort

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
	cmp.b	#NT_REPLYMSG,LN_TYPE(a1) ;=NT_REPLYMSG (back from HostPort?)
	beq.s	endsig
	CALLIB	ReplyMsg	;be polite and reply all unknown msgs
	bra.s	waitonm
endsig:		;got a 'reply' back from HostPort to 'our' msg

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

  END