/*
Ohjelma on vapaasti k‰ytett‰viss‰ ja muutettavissa, mutta jos
joku vaivautuisi tekem‰‰n nopeamman ja k‰yttˆliittym‰lt‰‰n
selke‰mm‰n version, niin voisi informoida kiinnostunutta...T‰m‰
on versio 0.0000000000001a. Ohjelmassa ei k‰ytet‰ edes
kaksoistarkkuuden liukulukuja, joita EC k‰‰nt‰j‰ 3.1 ei tunne.
Toimiva t‰m‰ on, mutta ei ohjelmointitaidollisesti selke‰.

Ohjelmalla tutkitaan muunnoskaavaa x -> 1-q*x*x, miss‰ q on
aluksi 0:n ja 2:n v‰lilt‰ ja x:n alkuarvo aina 0. Saatu arvo (x)
sijoitetaan taas kaavaan jne...

Ohjelma on tehty tavalla, josta ei kannata ottaa oppia: Koska
tekij‰ ei oikein hallitse, tai halua hallita IDCP_sun muita
lippuja, viestien l‰hett‰mist‰ prosesseilta toisille tai joitain:
WAIT_IDCP -juttuja, joissa pit‰isi vaan odotella, ett‰ jotain
tapahtusi ennenkuin saa mit‰‰n tehd‰, niin ohjelmassa luetaan
Mouse() funktiolla suoraan hiirirekisterin arvoa. Eli t‰m‰ ei
toimi oikein, jos ajat muuta ohjelmaa samalla ja painat siell‰
hiiren nappulaa (t‰m‰ ohjelma luulee ne "viesteiksi" itselleen).
Tied‰n, ett‰ Sakun ent. p‰‰toimittaja Janne Siren inhoaa
t‰llaisia ohjelmia.

Ohjelma on sekavasti tehty, ilman ett‰ toimintoja olisi jaettu
loogisiksi kokonaisuuksiksi aliohjelmiin. Kuten yleens‰kin
toisten ohjelmista on vaikea saada selkoa, niin t‰st‰ varsinkin.

"K‰yttˆliittym‰":

Ajon aikan voidaan zoomata tutkittavaa aluetta painamalla hiiren
oikeaa n‰pp‰int‰ uuden alueen vasemmassa yl‰kulmassa ja
vapauttamalla se oikeassa alakulmassa.

Yhten‰ pahana puutteena on ett‰ iteraatioiden lukum‰‰r‰‰ ei voida
ohjelman ajoaika muuttaa. Se voidaan kyll‰ antaa ohjelmalle syˆte
parametrina (oletusarvo 100). Mit‰‰n muita parametreja ei voi
antaa, koska E-kielell‰ ei ollut k‰ytett‰viss‰ni tarvittavia
moduuleja.

Ohjelman toiminta p‰‰ttyy painamalla hiiren vasenta n‰ppi‰.
*/

MODULE 'intuition/intuition', 'graphics/view',
        'checkaga'  /* jos haluat k‰‰nt‰‰ ohjelmaa E-k‰‰nt‰j‰ll‰,
        niin "checkaga" moduulin lˆyd‰t purkeista. Jos et lˆyd‰, niin
        poista t‰m‰ ja muuta ohjelmaa p‰‰ohjelman alusta(rivi 145).
        Sijoita muuttujan col arvoksi <256 (AGA) tai <16 (ei AGA) ja
        muuttujan tas arvot vastaavasti..(8-4).*/
CONST MAXX=640, MAXY=256

  /* n‰it‰ muuttujia on turha yritt‰‰ selitt‰‰ muille */
  DEF sptr=NIL, wptr=NIL, xn, xn1, x, y , q, fq, color, i,
  s[20]:STRING, t[20]:STRING, reunax=40, reunay=30, kork, lev,
  dx, dq,minx=4, miny=20, minc=9, ck, ym, xm, mousex, mousey,
   col, tas, xn0

/* Seuraavat arvot m‰‰r‰‰v‰t tarkasteltavan alueen.
   Niit‰ voi siis muuttaa ohjelman ajon aikana hiirell‰.
   Paina uuden alueen vasemmassa yl‰kulmassa hiiren oikeaa nappia,
   pid‰ alhaalla ja vapauta oikeassa alakulmassa
   x0 tai x1 eiv‰t ole sarjan alkuarvoja, vaan m‰‰r‰‰v‰t
   n‰ytett‰v‰n alueen: alkuarvo asetetaan noin rivill‰ 170 */

  DEF q0=0.0, q1=2.0, x0=-1.0, x1=1.1,

      maxiter=100, /* t‰m‰n voit siis syˆtt‰‰ ohjelmalle parametrina
                      Se kertoo kuinka monta sarjan j‰sent‰
                      kussakin pisteess‰ q lasketaan */

      miniter=0 /* t‰m‰ kertoo, kuinka monta lasketaan ilman plottausta
                  t‰t‰ k‰ytt‰en saadaan selke‰mmin selville todelliset
                  mahdolliset raja-arvot. Ei voi antaa parametrina */

PROC kaaoskohta(kohta,alas)
 /* Jos parametrina v‰litetty kohta on "kaaos"kohta, niin siit‰
    infoa n‰ytˆlle (jokatoinen alas, jokatoinen ylˆs) */
  IF (!q0<kohta) AND (!kohta<q1)
    x:=!kohta-q0/dq*(MAXX-minx-reunax!)+(reunax!)
    Line(!x!,miny+minx,!x!,MAXY-reunay,7)
    Colour(col-1,7)
    IF (alas=TRUE)
      TextF(!x!-6,MAXY-reunay+8,'\s',RealF(s,!kohta,3))
    ELSE
      TextF(!x!-6,miny+minx-2,'\s',RealF(t,!kohta,3))
    ENDIF
  ENDIF
ENDPROC

PROC raamit() /* asetetaan v‰rit ja piirret‰‰n n‰yttˆˆn raamit */
  SetColour(sptr,0,0,0,0)
  SetColour(sptr,1,160,140,80)
  SetColour(sptr,2,140,10,20)
  SetColour(sptr,3,255,255,0)
  SetColour(sptr,4,40,30,0)
  SetColour(sptr,5,215,255,30)
  SetColour(sptr,6,40,40,200)
  SetColour(sptr,7,155,55,120)
  SetColour(sptr,8,255,0,0)
  Box(reunax,miny+minx,MAXX-minx,MAXY-reunay,4)

  /*koitetaan saada v‰rit minc..col-1:een mustasta valkoiseen */
  FOR i:=minc TO col-1
    ck:=!(i-minc!)/(col-1-minc!)
    SetColour(sptr,i,!(255!)*ck!,!(255!)*ck!,!(255!)*ck!)
  ENDFOR

  Colour(col-1,6)
  TextF(MAXX-210,MAXY-4,'\s<q<\s',RealF(s,!q0,8),RealF(t,!q1,8))
  Colour(0,3)
  TextF(minx,MAXY-4,' x:=1-qxx, x0=\s',RealF(s,!xn0,4))
  Colour(5,7)
  TextF(reunax+220,MAXY-4,'\d<Iter<\d',miniter,maxiter)
  Colour(col-1,2)
  TextF(minx+4,miny+minx-2,'\s<x<\s',RealF(s,!x0,8),RealF(t,!x1,8))

  /* Merkataan joitakin "kriittisist‰" kaaoskohdista, jos n‰kyv‰t
                                joko alas(TRUE) tai ylˆs(FALSE) */
  kaaoskohta(0.75,FALSE)
  kaaoskohta(1.25,TRUE)
  kaaoskohta(1.368,FALSE)
  kaaoskohta(1.401,TRUE)

ENDPROC

PROC hiirenkoord()
/* Tulostaa n‰yttˆˆn hiiren osoitinta vastaavat x ja q koordinaatit */
/* v‰litet‰‰n ne tˆkerˆsti globaaleissa muuttujissa p‰‰ohjelmalle */
   mousex:=MouseX(wptr)
   mousey:=MouseY(wptr)
   ym:=!dq*(mousex-reunax!)/(lev!)+q0
   xm:=!dx*(mousey-miny-minx!)/(kork!)+x0
   Colour(col-1,6)
   TextF(MAXX-100,8,'q=\s',RealF(t,!ym,8))
   Colour(col-1,2)
   TextF(MAXX-260,8,'Hiiri x=\s',RealF(t,!xm,8))
ENDPROC
PROC avaaikkuna()  /* tosi tyhm‰ aliohjelma */
 wptr:=OpenW(0,0,MAXX,MAXY,NIL,NIL,'Feigenbaumin kaaos Keckmanin aikaansaamana',sptr,$F,NIL)
ENDPROC

PROC main()   /* p‰‰ohjelma alkaa siis t‰st‰ */
  DEF xm0, ym0, q0uusi, x0uusi, xk, yk, ok, mcode, alueella

  IF checkaga()=TRUE
    col:=64; tas:=6  /* jos AGA:lla haluat useampeja v‰rej‰, niin
                        sen kun lis‰‰ tasoja ja col m‰‰r‰‰.
                        V‰rirekistereiden arvot m‰‰r‰ytyv‰t raamit
                        -aliohjelmassa.
                        Ohjelmassa olisi voinut v‰rienk‰ytˆll‰
                        lis‰t‰ informaatiota: tulostaa esim, punaisella
                        todelliset lˆydet raja-arvot, mutta t‰ss‰
                        ei tehd‰ samoin kuin artikkelin ohjelmassa,
                        eli lasketa lukuja taulukkoon ja tutkita
                        lˆytyykˆ samoja...*/
  ELSE
    col:=16; tas:=4  /* ei AGA */
  ENDIF

  IF arg[]<>0           /* mit‰‰n t‰m‰n kummempaa maxiter -parametrin */
    maxiter:=Val(arg)   /* syˆttˆrutiinia ei tullut rakenneltua */
  ENDIF


  sptr:=OpenS(MAXX, MAXY, tas,V_HIRES,'')
  IF sptr
      avaaikkuna()
    IF wptr
       dx:=!x1-x0
       dq:=!q1-q0
       !xn0:=0.0   /* Asetetaan alkuarvo Huom: desimaali piste */
                   /* voit muuttaa (mutta vain t‰st‰) */
      raamit()     /* p‰‰ohjelma olisi pitk‰ kuin makarooni, jos
                      en olisi vaivautunut pist‰m‰‰n edes t‰t‰
                      aliohjelmaksi.
                      Yleens‰ mit‰ lyhk‰sempi p‰‰ohjelma sit‰
                      selke‰mmin toiminnot on jaettu loogisisesti
                      j‰rkeviksi aliohjelmiksi. T‰m‰ tiedoksi
                      muille.   */
      REPEAT
        kork:=MAXY-miny-minx-reunay
        lev:=MAXX-reunax-minx
        q:=reunax
        REPEAT   /* t‰st‰ alkaa pisteiden plottaus kunnes q=MAXX-minx */
                 /* q ei ole siis itseasissa q vaan x-koordinaatti */
          !fq:=!dq*(q!-(reunax!))/(MAXX-minx-reunax!)+q0
                 /* fq on sit‰ vastaava q */
          xn1:=xn0
          i:=1
          color:=minc
          hiirenkoord()
          REPEAT /* t‰ss‰ on varsinainen iteraatio looppi */
            xn:=xn1
            xn1:=!1.0-(!fq*xn*xn)
            IF (!xn1<(!x1)) AND (!xn1>(!x0)) /* onko n‰kyviss‰ */
              y:=!xn1-x0/dx*(kork!)+(minx+miny!)
              IF (xn=xn1)      /* samat valkoisella */
                color:=col-1
                Plot(q,!y!,color)
              ELSE
                IF i>miniter         /* ja plotataanko myˆs*/
                  color:=Bounds(color+1,minc,col-1)
                  Plot(q,!y!,color)
                ENDIF
              ENDIF
            ENDIF /* sille , ett‰ oliko alueella */
            INC i
            mcode:=Mouse()  /* t‰m‰ luetaan vaikka olisit toista
                               ohjelmaa k‰ytt‰m‰ss‰: ‰lk‰‰ koskaan
                               ohjelmoiko n‰in */
          UNTIL (i>maxiter) OR (xn=xn1) OR (mcode=1)
          INC q
          alueella:= (!ym>q0) AND (!xm>x0) AND (!ym<q1) AND (!xm<x1)
        UNTIL (q=(MAXX-minx)) OR ((mcode=2) AND alueella) OR (mcode=1)

        IF mcode=2  /* k‰ytt‰j‰ valitsee uuden tutkittavan alueen..*/
            hiirenkoord()   /* t‰st‰ eteenp‰in ohjelma menee  */
            q0uusi:=ym      /* entist‰ sekavammaksi */
            x0uusi:=xm
            xm0:=mousex
            ym0:=mousey
              Line(mousex,mousey,mousex,MAXY-reunay,2)
              Line(mousex,mousey,MAXX-reunax,mousey,2)
              xk:=Bounds(mousex,reunax,MAXX-176)
              yk:=Bounds(mousey,reunay,MAXY-reunay)
              Colour(2,7)
              TextF(xk,yk-20,'Siirr‰ uuteen oikeaan alakulmaan')
              TextF(xk,yk-8, 'ja vapauta oikea n‰pysk‰')
              REPEAT
                REPEAT
                  mousex:=MouseX(wptr)
                  mousey:=MouseY(wptr)
                  IF (mousex>xm0) AND (mousey>ym0)
                    Plot(xm0,mousey,col-1)
                    Plot(mousex,ym0,col-1)
                    Delay(1)
                    Plot(xm0,mousey,2)
                    Plot(mousex,ym0,2)
                  ENDIF
                UNTIL (Mouse()<>2) /* kunnes nostetaan oikea n‰pysk‰...*/
                IF (mousey<ym0) OR (mousex<xm0)
                            /*..oikealla paikkaa*/
                  TextF(xk,yk+20,'Siis _oikeaan_ _ala_kulmaan!')
                  TextF(xk,yk+28,'Paina ja vapauta uudestaan')
                  WHILE(Mouse()<>2);ENDWHILE
                  ok:=FALSE
                ELSE
                  ok:=TRUE
                ENDIF
              UNTIL ok
              hiirenkoord()
              q1:=ym
              x1:=xm
              x0:=x0uusi
              q0:=q0uusi
              dx:=!x1-x0
              dq:=!q1-q0
              IF wptr THEN CloseW(wptr)
              avaaikkuna()
              raamit()
        ENDIF   /* t‰ss‰ vasta loppu se IF, ett‰ oliko mcode=2 (RMB)*/
      UNTIL (mcode=1)  /* ohjelma ei lopu kuin vasenta nappia painamalla*/
     ELSE
        WriteF('Ikkunaa ei voi avata\n')
     ENDIF
   ELSE
      WriteF('N‰yttˆ‰ ei voi avata\n')
   ENDIF
   IF wptr THEN CloseW(wptr)
   IF sptr THEN CloseS(sptr)
ENDPROC

