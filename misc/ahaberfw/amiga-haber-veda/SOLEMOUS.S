*****************************************************************************
*          SOLE MOUSE DRIVER                                                *
* Compiler: PhxAss                                                   ORHAN  *
*****************************************************************************
           MACHINE     MC68000
           INCLUDE     "exec/types.i"
           INCLUDE     "exec/memory.i"
           INCLUDE     "exec/execbase.i"
           INCLUDE     "exec/tasks.i"
           INCLUDE     "exec/macros.i"
           INCLUDE     "dos/dos.i"
           INCLUDE     "devices/input.i"
           INCLUDE     "devices/inputevent.i"
           INCLUDE     "devices/serial.i"
           INCLUDE     "lvo/exec_lib.i"
           INCLUDE     "lvo/dos_lib.i"

VERSION    EQU         1      ;0<>9
REVISION   EQU         0      ;0<>9
TASKPRI    EQU         18
TASKSTK    EQU         4096

           STRUCTURE   MyTaskBase,TC_SIZE
           APTR        my_NOTIFYTASK
           APTR        my_INPUTPORT
           APTR        my_INPUTREQ
           APTR        my_SERIALPORT
           APTR        my_SERIALREQ
           STRUCT      my_INPUTEVENT1,ie_SIZEOF       ;STRUCTURE InputEvent
           STRUCT      my_INPUTEVENT2,ie_SIZEOF       ;STRUCTURE InputEvent
           STRUCT      my_INPUTEVENT3,ie_SIZEOF       ;STRUCTURE InputEvent
           BYTE        my_SERIALBYTE
           BYTE        my_MAINFLAG
           ALIGNLONG
           STRUCT      my_TaskStack,TASKSTK
           LABEL       MyTaskBase_Sizeof

           BITDEF      FLAG,OPENINPUT,0    ;0= closed, 1= opened
           BITDEF      FLAG,OPENSERIAL,1   ;0= closed, 1= opened
           BITDEF      FLAG,FIRSTBYTE,2    ;1= first byte exist
           BITDEF      FLAG,SECONDBYTE,3   ;1= second byte exist
           BITDEF      FLAG,LMB,4          ;left mouse button status
           BITDEF      FLAG,RMB,5          ;right mouse button status
*****************************************************************************
*          start                                                            *
*****************************************************************************
           SECTION     "CODE",CODE
           MOVE.L      ($4),A6
           CMP.W       #39,LIB_VERSION(A6)             ;check KS3.0
           BLT         AA0

           LEA.L       TCBMEMLIST,A0
           CALLSYS     AllocEntry
           BCLR.L      #31,D0
           BNE         AA0
           MOVE.L      D0,A2                           ;new memlist

           MOVE.L      TASKBASE-TCBMEMLIST(A2),A3      ;task base
           MOVE.L      TASKCODE-TCBMEMLIST(A2),A4      ;task code

           LEA.L       MYTASK,A0
           MOVE.L      A4,A1
           MOVE.L      #ENDCODE-MYTASK-1,D0
AA8:       MOVE.B      (A0)+,(A1)+
           DBF         D0,AA8

           CALLSYS     CacheClearU

           LEA.L       TC_MEMENTRY(A3),A0              
           MOVE.L      A2,A1                           
           NEWLIST     A0                              ;initialize list
           ADDHEAD                                     ;add new memlist

           MOVE.L      ThisTask(A6),my_NOTIFYTASK(A3)

           MOVE.B      #NT_TASK,LN_TYPE(A3)
           MOVE.B      #TASKPRI,LN_PRI(A3)
           LEA.L       MYNAME-MYTASK(A4),A0
           MOVE.L      A0,LN_NAME(A3)
           LEA.L       my_TaskStack(A3),A0
           MOVE.L      A0,TC_SPLOWER(A3)
           ADD.L       #TASKSTK,A0
           MOVE.L      A0,TC_SPUPPER(A3)
           MOVE.L      A0,TC_SPREG(A3)

           MOVE.L      A3,A1
           MOVE.L      A4,A2
           CLEARA      A3
           CALLSYS     AddTask

           MOVE.L      #SIGBREAKF_CTRL_E|SIGBREAKF_CTRL_F,D0
           CALLSYS     Wait
           BTST.B      #SIGBREAKB_CTRL_E,D0
           BEQ         AA0

           MOVE.L      #RETURN_OK,D3
           BRA         AA20
AA0:
           MOVE.L      #ERROR_NOT_IMPLEMENTED,D3

           LEA.L       DOSNAME,A1
           CLR.L       D0
           CALLSYS     OpenLibrary
           TST.L       D0
           BEQ         AA20

           MOVE.L      D0,A6
           MOVE.L      D3,D1
           CLR.L       D2
           CALLSYS     PrintFault

           MOVE.L      A6,A1
           MOVE.L      ($4),A6
           CALLSYS     CloseLibrary
AA20:
           MOVE.L      D3,D0
           RTS
*****************************************************************************
*          data                                                             *
*****************************************************************************
TCBMEMLIST:
           DCB.B       LN_SIZE                   ;STRUCTURE ML,LN_SIZE
           DC.W        2                         ;UWORD ML_NUMENTRIES
TASKBASE   DC.L        MEMF_PUBLIC|MEMF_CLEAR    ;LABEL ML_ME      (ME_REQS)
           DC.L        MyTaskBase_Sizeof         ;                 (ME_LENGTH)
TASKCODE   DC.L        MEMF_PUBLIC
           DC.L        ENDCODE-MYTASK
           CNOP        0,4
*****************************************************************************
*          my task                                                          *
*****************************************************************************
MYTASK:
           MOVE.L      ($4),A6
           MOVE.L      ThisTask(A6),A5              ;task base

           CALLSYS     CreateMsgPort
           MOVE.L      D0,my_INPUTPORT(A5)
           BEQ         CLEANEXIT
           MOVE.L      D0,A0
           MOVE.L      #IOSTD_SIZE,D0
           CALLSYS     CreateIORequest
           MOVE.L      D0,my_INPUTREQ(A5)
           BEQ         CLEANEXIT

           LEA.L       INPUTNAME,A0
           MOVE.L      my_INPUTREQ(A5),A1
           CLR.L       D0
           CLR.L       D1
           CALLSYS     OpenDevice
           TST.L       D0
           BNE         CLEANEXIT
           BSET.B      #FLAGB_OPENINPUT,my_MAINFLAG(A5)

           CALLSYS     CreateMsgPort
           MOVE.L      D0,my_SERIALPORT(A5)
           BEQ         CLEANEXIT
           MOVE.L      D0,A0
           MOVE.L      #IOEXTSER_SIZE,D0
           CALLSYS     CreateIORequest
           MOVE.L      D0,my_SERIALREQ(A5)
           BEQ         CLEANEXIT

           MOVE.L      my_SERIALREQ(A5),A0
           LEA.L       MN_SIZE(A0),A0
           MOVE.L      #IOEXTSER_SIZE-MN_SIZE-1,D0
AA9:       CLR.B       (A0)+
           DBF         D0,AA9

           LEA.L       SERNAME,A0
           MOVE.L      my_SERIALREQ(A5),A1
           MOVE.L      #SERF_RAD_BOOGIE|SERF_XDISABLED,D7
           MOVE.B      D7,IO_SERFLAGS(A1)
           CLR.L       D0
           CLR.L       D1
           CALLSYS     OpenDevice
           TST.L       D0
           BNE         CLEANEXIT
           BSET.B      #FLAGB_OPENSERIAL,my_MAINFLAG(A5)

           MOVE.L      my_SERIALREQ(A5),A1
           MOVE.W      #SDCMD_SETPARAMS,IO_COMMAND(A1)
           MOVE.B      D7,IO_SERFLAGS(A1)
           MOVE.B      #7,IO_READLEN(A1)
           MOVE.B      #1,IO_STOPBITS(A1)
           MOVE.L      #4800,IO_BAUD(A1)       ;4800 icin RMB ye basilmalidir
           MOVE.L      #64,IO_RBUFLEN(A1)
           CALLSYS     DoIO
           TST.L       D0
           BNE         CLEANEXIT
AA41:
           MOVE.L      my_SERIALREQ(A5),A1
           MOVE.W      #CMD_READ,IO_COMMAND(A1)
           LEA.L       my_SERIALBYTE(A5),A0
           MOVE.L      A0,IO_DATA(A1)
           MOVE.L      #1,IO_LENGTH(A1)
           CALLSYS     DoIO
           TST.L       D0
           BNE         CLEANEXIT
           MOVE.B      my_SERIALBYTE(A5),D0
           AND.B       #$7F,D0
           CMP.B       #$7F,D0
           BEQ         AA41
           CMP.B       #$4D,D0                   ;'M' means mouse okay
           BNE         CLEANEXIT

           MOVE.L      my_NOTIFYTASK(A5),A1
           CLR.L       my_NOTIFYTASK(A5)
           MOVE.L      #SIGBREAKF_CTRL_E,D0
           CALLSYS     Signal
*****************************************************************************
*          read serial                                                      *
*****************************************************************************
AA7:
           MOVE.L      my_SERIALREQ(A5),A1
           MOVE.W      #CMD_READ,IO_COMMAND(A1)
           LEA.L       my_SERIALBYTE(A5),A0
           MOVE.L      A0,IO_DATA(A1)
           MOVE.L      #1,IO_LENGTH(A1)
           CALLSYS     DoIO
           TST.L       D0
           BNE         AA7

           MOVE.B      my_SERIALBYTE(A5),D2
           BTST.L      #6,D2
           BEQ         AA11
           LSL.L       #8,D2
           BSET.B      #FLAGB_FIRSTBYTE,my_MAINFLAG(A5)
           BCLR.B      #FLAGB_SECONDBYTE,my_MAINFLAG(A5)
           BRA         AA7
AA11:      BTST.B      #FLAGB_FIRSTBYTE,my_MAINFLAG(A5)
           BEQ         AA7
           BSET.B      #FLAGB_SECONDBYTE,my_MAINFLAG(A5)
           BNE         AA12
           LSL.L       #8,D2
           BRA         AA7
AA12:      BCLR.B      #FLAGB_FIRSTBYTE,my_MAINFLAG(A5)

;------------------------
;23 22 21 20 19 18 17 16|
; -  1  L  R Y7 Y6 X7 X6|
;                       |
;15 14 13 12 11 10  9  8|
; -  0 X5 X4 X3 X2 X1 X0|
;                       |
; 7  6  5  4  3  2  1  0|
; -  0 Y5 Y4 Y3 Y2 Y1 Y0|
;------------------------

           LEA.L       my_INPUTEVENT1(A5),A0
           CLR.L       ie_NextEvent(A0)
           MOVE.B      #IECLASS_RAWMOUSE,ie_Class(A0)
           CLR.B       ie_SubClass(A0)
           CLR.L       ie_EventAddress(A0)

           BTST.B      #21,D2
           BNE         AA13
           BCLR.B      #FLAGB_LMB,my_MAINFLAG(A5)
           BEQ         AA15
           MOVE.W      #IECODE_UP_PREFIX|IECODE_LBUTTON,ie_Code(A0)
           CLR.W       ie_Qualifier(A0)
           BRA         AA14
AA13:      BSET.B      #FLAGB_LMB,my_MAINFLAG(A5)
           BNE         AA15
           MOVE.W      #IECODE_LBUTTON,ie_Code(A0)
           MOVE.W      #IEQUALIFIER_LEFTBUTTON,ie_Qualifier(A0)
AA14:      BSR         WRITEEVENT
AA15:
           LEA.L       my_INPUTEVENT2(A5),A0
           CLR.L       ie_NextEvent(A0)
           MOVE.B      #IECLASS_RAWMOUSE,ie_Class(A0)
           CLR.B       ie_SubClass(A0)
           CLR.L       ie_EventAddress(A0)

           BTST.B      #20,D2
           BNE         AA17
           BCLR.B      #FLAGB_RMB,my_MAINFLAG(A5)
           BEQ         AA16
           MOVE.W      #IECODE_UP_PREFIX|IECODE_RBUTTON,ie_Code(A0)
           CLR.W       ie_Qualifier(A0)
           BRA         AA18
AA17:      BSET.B      #FLAGB_RMB,my_MAINFLAG(A5)
           BNE         AA16
           MOVE.W      #IECODE_RBUTTON,ie_Code(A0)
           MOVE.W      #IEQUALIFIER_RBUTTON,ie_Qualifier(A0)
AA18:      BSR         WRITEEVENT
AA16:
           MOVE.B      D2,D0
           AND.B       #%00111111,D0
           LSR.L       #8,D2
           MOVE.B      D2,D1
           AND.B       #%00111111,D1
           LSR.L       #8,D2
           MOVE.B      D2,D3
           LSL.B       #6,D3
           OR.B        D3,D1
           EXT.W       D1
           LSR.B       #2,D2
           LSL.B       #6,D2
           OR.B        D2,D0
           EXT.W       D0

           MOVE.W      D0,D2
           OR.W        D1,D2
           BEQ         AA7

           LEA.L       my_INPUTEVENT3(A5),A0
           CLR.L       ie_NextEvent(A0)
           MOVE.B      #IECLASS_RAWMOUSE,ie_Class(A0)
           CLR.B       ie_SubClass(A0)
           MOVE.W      #IECODE_NOBUTTON,ie_Code(A0)
           MOVE.W      D1,ie_X(A0)
           MOVE.W      D0,ie_Y(A0)
           MOVE.W      #IEQUALIFIER_RELATIVEMOUSE,ie_Qualifier(A0)
           BSR         WRITEEVENT
           BRA         AA7
*****************************************************************************
*          write event   A0= InputEvent                                     *
*****************************************************************************
WRITEEVENT:
           MOVE.L      my_INPUTREQ(A5),A1
           MOVE.W      #IND_WRITEEVENT,IO_COMMAND(A1)
           MOVE.L      A0,IO_DATA(A1)
           MOVE.L      #ie_SIZEOF,IO_LENGTH(A1)
           CALLSYS     DoIO
           RTS
*****************************************************************************
*          clean exit                                                       *
*****************************************************************************
CLEANEXIT:
           BTST.B      #FLAGB_OPENSERIAL,my_MAINFLAG(A5)
           BEQ         AA1
           MOVE.L      my_SERIALREQ(A5),A1
           CALLSYS     CloseDevice
AA1:
           MOVE.L      my_SERIALREQ(A5),A0
           CMP.L       #0,A0
           BEQ         AA2
           CALLSYS     DeleteIORequest
AA2:
           MOVE.L      my_SERIALPORT(A5),A0
           CMP.L       #0,A0
           BEQ         AA3
           CALLSYS     DeleteMsgPort
AA3:
           BTST.B      #FLAGB_OPENINPUT,my_MAINFLAG(A5)
           BEQ         AA4
           MOVE.L      my_INPUTREQ(A5),A1
           CALLSYS     CloseDevice
AA4:
           MOVE.L      my_INPUTREQ(A5),A0
           CMP.L       #0,A0
           BEQ         AA5
           CALLSYS     DeleteIORequest
AA5:
           MOVE.L      my_INPUTPORT(A5),A0
           CMP.L       #0,A0
           BEQ         AA6
           CALLSYS     DeleteMsgPort
AA6:
           MOVE.L      my_NOTIFYTASK(A5),A1
           CMP.L       #0,A1
           BEQ         AA10
           MOVE.L      #SIGBREAKF_CTRL_F,D0
           CALLSYS     Signal
AA10:
           MOVE.L      #0,D0
           RTS
*****************************************************************************
*          data                                                             *
*****************************************************************************
DOSNAME    DC.B        'dos.library',0
INPUTNAME  DC.B        'input.device',0
SERNAME    DC.B        'serial.device',0
MYNAME     DC.B        'SoleMouse',0
IDSTRING   DC.B        '$VER: SoleMouse',32,VERSION+48,46,REVISION+48,32
           DC.B        '(01.9.97) © OR',13,10,0
ENDCODE:
           END
