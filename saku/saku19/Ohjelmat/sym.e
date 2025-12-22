MODULE 'intuition/intuition', 'graphics/view'
CONST V_LORES=0
  DEF sptr=NIL, wptr=NIL, x, y, minx=4, miny=10, maxx, maxy, color=1
  DEF i, kx, ky, lev, kork
PROC main()

  sptr:=OpenS(320,256,4,V_LORES,' PITSILIINOJA - TAI LUMIHIUTALEITA')
  maxx:=320-minx
  maxy:=256-miny
  IF sptr
    wptr:=OpenW(minx,miny,maxx,maxy,IDCMP_CLOSEWINDOW,
                WFLG_CLOSEGADGET OR WFLG_ACTIVATE,
                ' RMB:pause, LMB: lopetus',sptr,$F,NIL)
    IF wptr
      FOR i:=2 TO 16
            SetColour(sptr,i,Rnd(256),Rnd(256),Rnd(256))
      ENDFOR
      lev:=(maxx-minx-1)/8
      kork:=(maxy-miny-1)/6
      kx:=minx+(lev/2)+2
      ky:=miny+(kork/2)+2
      i:=Rnd(Val(arg))  /* alustaa "satunnaisluku" generaattorin
                           antamasi syötteen perusteella */
      WHILE Mouse()<>1
      x:=0
      y:=0
      Box(kx-(lev/2)+1,ky-(kork/2)+1,kx+(lev/2)-1,ky+(kork/2)-1,1)
      FOR i:=1 TO 100
        INC color
        Plot(kx+x,ky+y,color)
        Plot(kx+x,ky-y,color)
        Plot(kx-x,ky-y,color)
        Plot(kx-x,ky+y,color)
        Plot(kx+y,ky+x,color)
        Plot(kx-y,ky+x,color)
        Plot(kx-y,ky-x,color)
        Plot(kx+y,ky-x,color)
        x:=x+2-Rnd(5)
        y:=y+1-Rnd(3)
        IF Abs(x)>(lev/2-2) THEN x:=0
        IF Abs(y)>(kork/2-2) THEN y:=0
      ENDFOR
      kx:=kx+lev
      IF kx>(maxx+minx)
        kx:=minx+(lev/2)+2
        ky:=ky+kork
        IF ky>(maxy+miny) THEN ky:=miny+(kork/2)+2
      ENDIF
      ENDWHILE
    ELSE
      WriteF('Could not open window\n')
    ENDIF
  ELSE
    WriteF('Could not open screen\n')
  ENDIF
  IF wptr THEN CloseW(wptr)
  IF sptr THEN CloseS(sptr)
ENDPROC
