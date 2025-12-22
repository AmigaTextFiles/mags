* --------------------------------------
* ( Simple ) - Library Installation V1.0
* --------------------------------------
* © 22-02-96 Volker Stepprath, Testaware
* --------------------------------------

            opt     o+

            move.l  $4.w,a6
            suba.l  a1,a1
            jsr     -294(a6)
            move.l  d0,a4
            tst.l   $AC(a4)
            bne.s   fromCLI
            lea     $5C(a4),a0
            jsr     -384(a6)
            jsr     -372(a6)
fromCLI     lea     DosLib(pc),a1
            clr.l   d0
            jsr     -552(a6)
            move.l  d0,a6
            beq.s   Ende
            move.l  #LibName,d1
            move.l  #1006,d2
            jsr     -30(a6)
            move.l  d0,DosLib
            beq.s   CLib
            move.l  DosLib,d1
            move.l  #LibStart,d2
            move.l  #LibEnd,d3
            sub.l   d2,d3
            jsr     -48(a6)
            move.l  DosLib,d1
            jsr     -36(a6)
CLib        movea.l a6,a1
            move.l  $4.w,a6
            jsr     -414(a6)
Ende        rts

DosLib      dc.b    "dos.library",0
LibName     dc.b    "DF0:LIBS/powerpacker.library",0    ; Libname out
LibStart    Incbin  "DF0:LIBS/powerpacker.library"      ; Libname in!
LibEnd

            END
