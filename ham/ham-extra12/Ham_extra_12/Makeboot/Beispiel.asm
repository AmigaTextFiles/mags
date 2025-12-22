
Execbase        equ     $4
OpenLibrary     equ     -552
CloseLibrary    equ     -414
FindResident    equ     -96
init            equ     22
HIRES           equ     $8000
CUSTOMSCREEN    equ     $000F
SCREENQUIET     equ     $0100
OpenScreen      equ     -198
CloseScreen     equ     -66
SetRGB4         equ     -288
TextLength      equ     -54
Text            equ     -60
SetAPen         equ     -342
Move            equ     -240
Draw            equ     -$f6
WritePixel      equ     -$144
rport           equ     84
vport           equ     44
version         equ     20

infolaenge      equ     46
infolaenge2     equ     55
infolaenge3     equ     40


    CODE

start:

    movem.l d0-d7/a0-a6,-(sp)   ;   benutzte Register retten

    move.l  Execbase,a6         ;   execbase-Adresse nach a6
    lea     intuitionlib(pc),a1 ;   Name der Intuition-Library nach a1
    clr.l   d0                  ;   d0 löschen
    jsr     OpenLibrary(a6)     ;   Intuition-Library öffnen
    lea     intuitionbase(pc),a1    ;   Intuition-Library sichern
    move.l  d0,(a1)

    lea     graphicslib(pc),a1  ;   Name der GFX-Library nach a1
    clr.l   d0                  ;   d0 löschen
    jsr     OpenLibrary(a6)     ;   GFX-Library öffnen
    lea     graphicsbase(pc),a1 ;   GFX-Library sichern
    move.l  d0,(a1)

    move.l  intuitionbase(pc),a6
    lea     newscreen(pc),a0
    jsr     OpenScreen(a6)
    lea     screen(pc),a1
    move.l  d0,(a1)

    move.l  graphicsbase(pc),a6
    move.l  screen(pc),a2
    lea     vport(a2),a1
    move.l  a1,d0
    lea     viewport(pc),a1
    move.l  d0,(a1)
    move.l  viewport(pc),a0

    bsr     cleards

    jsr     SetRGB4(a6)

    move.l  #1,d0
    move.l  viewport(pc),a0
    jsr     SetRGB4(a6)

    move.l  screen(pc),a2
    lea     rport(a2),a1

    move.l  #10,d0
    move.l  #62,d1
    jsr     Move(a6)

    move.l  #1,d0
    jsr     SetAPen(a6)

    lea     infotext(pc),a0
    move.l  #infolaenge,d0
    jsr     Text(a6)

    move.l  screen(pc),a2
    lea     rport(a2),a1

    move.l  #10,d0
    move.l  #82,d1
    jsr     Move(a6)

    lea     infotext2(pc),a0
    move.l  #infolaenge2,d0
    jsr     Text(a6)

    move.l  screen(pc),a2
    lea     rport(a2),a1

    move.l  #10,d0
    move.l  #102,d1
    jsr     Move(a6)

    lea     infotext3(pc),a0
    move.l  #infolaenge3,d0
    jsr     Text(a6)

    move.l  screen(pc),a2
    lea     rport(a2),a1

    move.l  #0,d4
    bsr     cleards

fadeloop:
    move.l  #1,d0
    move.l  d4,d1
    move.l  d4,d2
    move.l  d4,d3
    move.l  viewport(pc),a0
    jsr     SetRGB4(a6)
    add.l   #1,d4

    move.l  #0,d1
schleife:
    add.l   #1,d1
    cmp.l   #$b000,d1
    bne     schleife

    cmp     #15,d4
    bne     fadeloop

    bsr     mousewait           ;   auf Mausklick warten

cleards:
    moveq.l #0,d0
    moveq.l #0,d1
    moveq.l #0,d2
    moveq.l #0,d3
    rts

mousewait:

    btst    #6,$bfe001          ;   rechte Maustaste wird abgefragt
    bra     mousewait           ;   evtl. weiter warten


doslibrary:

    dc.b    "dos.library",0
    even

intuitionlib:

    dc.b    "intuition.library",0
    even

intuitionbase:

    dc.l    0
    even

graphicslib:

    dc.b    "graphics.library",0
    even

graphicsbase:

    dc.l    0
    even

newscreen:

    dc.w    0           ;   LeftEdge
    dc.w    0           ;   TopEdge
    dc.w    640         ;   Width
    dc.w    256         ;   Height
    dc.w    1           ;   Depth
    dc.b    $ff,$ff     ;   DetailPen und BlockPen
    dc.w    HIRES       ;   ViewModes
    dc.w    CUSTOMSCREEN+SCREENQUIET    ;   ScreenTyp
    dc.l    0           ;   Font
    dc.l    0           ;   Title
    dc.l    0           ;   Gadgets
    dc.l    0           ;   CustomBitMap
    even

screen:

    dc.l    0
    even

viewport:

    dc.l    0
    even

infotext:
    dc.b    "Hallo! Diese Disk ist von Kopf bis Fuß _nicht_",0
    even

infotext2:
    dc.b    "auf's Booten eingestellt. Sorry. Deshalb sollte man die",0
    even

infotext3:
    dc.b    "WB laden und dann die Disk bewundern ;-)",0
    even


    end
