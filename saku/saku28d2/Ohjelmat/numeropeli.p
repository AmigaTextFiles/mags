Program Numeropeli;

{ By Petri Keckman, http://www.mbnet.fi/~keckman }

{ GiftWare. You send me something? }

{ Compiled with PCQ-Pascal 2.1 (1.2d works too) }

{ Idea in game: Pick up as big numbers as you can (by rows in this version)}
{ The Amiga will win You!! There is a gametree intelligence in this game! }

{ Feel free to resize the window - program use SuperBitMap Structure }

{ The language I use in remarks and variable's names is mainly in finnish after these
  lines }

{$I "Include:Graphics/Gfx.i"}
{$I "Include:Graphics/Rastport.i"}
{$I "Include:Graphics/View.i"}
{$I "Include:Graphics/Pens.i"}
{$I "Include:Graphics/Text.i"}
{$I "Include:Exec/Exec.i"}
{$I "Include:Graphics/Gels.i"}
{$I "Include:Intuition/Intuition.i"}
{$I "Include:Libraries/GadTools.i"}
{$I "Include:PCQUtils/Utils.i"}
{$I "Include:PCQUtils/IntuiUtils.i"}
{$I "include:utils/stringlib.i"}
{$I "Include:Utils/Random.i"}
{$I "Include:dos/dos.i"}

CONST
    nm   : ARRAY[0..4] OF NewMenu=(
        (NM_TITLE, "Project",NIL,0,0,NIL),
        (NM_ITEM,  "New",    NIL,0,0,NIL),
        (NM_ITEM,  "Config", NIL,0,0,NIL),
        (NM_ITEM,  "Exit",   NIL,0,0,NIL),
        (NM_END,    NIL,     NIL,0,0,NIL));

    tyhja=MININT;
    tahti=MAXINT;
    minminarvo=-99;
    maxmaxarvo=99;
    maxmaxind=20;
    saroja=24;

TYPE indtype = 1..maxmaxind;
     arvot   = minminarvo..maxmaxarvo;
     solmuos = ^solmu;
     solmu   = RECORD
                  arvo:Integer;
                  ind :Indtype;
                  oikveli:solmuos;
               END;
     puu     = ^puutaso;
     puutaso = RECORD
                  ylataso:puu;
                  siirrot:solmuos;
                  parasarvo:INTEGER;
               END;
VAR
    w           : WindowPtr;
    s           : ScreenPtr;
    vi          : Address;
    IPtr        : IntuiMessagePtr;
    Msg         : MessagePtr;
    UsedMemory  : RememberPtr;
    rp          : RastPortPtr;
    MyTmpRas    : TmpRas;
    MyTmpRasPtr : PLANEPTR;   {Pit‰‰ olla Chip-muistia}
    sx,sy       : SHORT;
    MenuStrip   : MenuPtr;
    quit        : BOOLEAN;
    maxind      : SHORT;
    Str         : String;
    nkx,nky     : Real;
    TopazFont   : TextFontPtr;
CONST
    MyTextAttr : TextAttr = ("topaz.font",11,FS_NORMAL,FPF_ROMFONT);
    WINDOWFLAGS = WFLG_GIMMEZEROZERO or WFLG_DRAGBAR or WFLG_SIZEGADGET or
          WFLG_DEPTHGADGET or WFLG_CLOSEGADGET or WFLG_ACTIVATE or WFLG_NEWLOOKMENUS;
    nw  : NewWindow = (
        20, 20,                 { start position               }
        350, 230,               { width, height                }
        -1, -1,                 { detail pen, block pen        }
        IDCMP_CLOSEWINDOW or IDCMP_NEWSIZE or IDCMP_MENUPICK or IDCMP_MOUSEBUTTONS ,  { IDCMP flags    }
        WINDOWFLAGS,            { window flags                 }
        Nil,                    { pointer to first user gadget }
        Nil,                    { pointer to user checkmark    } 
        "Numeropeli, Made in Finland 1999 Petri Keckman",   { window title         }
        Nil,                    { pointer to screen    (later) }
        Nil,                    { pointer to superbitmap       }
        280,200,-1,-1,            { sized window }
        WBENCHSCREEN_f          { type of screen in which to open }
        );
    pi:Real=3.1415926535;

VAR
    kayttamattomat:     puu;    {Solmuja ei tuhota ja luoda yhten‰‰n, vaan laitetaan ja}
                                {otetaan kayttamattomat listaan}
    kayttamattsolmut:   solmuos;
    koneenlaatat,
    pelaajanlaatat,
    taso,
    maxtaso,
    koneyht,pelayht :   INTEGER;
    minarvo,
    maxarvo:Integer;
    konesarakkeittain,
    koneenvuoro,
    pelipaattyi     :   BOOLEAN;
    laudantekotapa:
    (kaikkiarvotaan,
    vanhaalkutilanne);
    tahtirivi,
    tahtisara,
    edtahtirivi,
    edtahtisara     :   indtype;
    alkutilanne     :   ARRAY [1..maxmaxind,1..maxmaxind] OF INTEGER;
    pelilauta       :   ARRAY [1..maxmaxind,1..maxmaxind] OF INTEGER;
    sinit           :   ARRAY [1..saroja] OF SHORT;
    cosit           :   ARRAY [1..saroja] OF SHORT;


PROCEDURE TULOSTA(Str:String;x,y,v1,v2:SHORT);
VAR l:INTEGER;
BEGIN
    SetDrMd(rp,1);
    l:=StrLen(Str);
    SetAPen(rp,v1);
    SetBPen(rp,v2);
    Move(rp,x,y);
    GText(rp,Str,l);
END;

PROCEDURE TULOSTAN(N:INTEGER;x,y,v1,v2:SHORT);
VAR l:INTEGER;
BEGIN
    l:=IntToStr(Str,N);
    TULOSTA(Str,x,y,v1,v2);
END;

PROCEDURE Nelio(x1,y1,x2,y2:SHORT);
BEGIN
  move(rp,x1,y1);
  draw(rp,x2,y1);
  draw(rp,x2,y2);
  draw(rp,x1,y2);
  draw(rp,x1,y1);
END;

PROCEDURE BOX(ri,sa,v,offset:SHORT);  {Piirt‰‰ Boxin laatan rivi=ri,sara=sa kohdalle}
VAR x,y:SHORT;
BEGIN
    x:=0.25*nkx+(sa-1)*nkx+offset;
    y:=13+nky+(ri-1)*nky+offset;
    SetAPen(rp,v);
    Nelio(x,y,x+nkx-2*offset,y+nky-2*offset);
END;

PROCEDURE FBOX(ri,sa,v,offset:SHORT);    {Filled Boxi}
VAR x,y:SHORT;
BEGIN
  x:=0.25*nkx+(sa-1)*nkx+offset;
  y:=13+nky+(ri-1)*nky+offset;
  SetAPen(rp,v);
  RectFill(rp,x,y,x+nkx-2*offset,y+nky-2*offset);
END;

PROCEDURE PIIRRATAH(ri,sa:SHORT);     {t‰htilaatan piirto}
VAR lkm,x,y,x2,y2,kx,ky,rx,ry:SHORT;
    i:INTEGER;
BEGIN
    BOX(ri,sa,4,1);
    BOX(ri,sa,5,2);
    FBOX(ri,sa,3,4);
    kx:=0.25*nkx+(sa-0.5)*nkx;
    ky:=13+nky+(ri-0.5)*nky;
    move(rp,kx+cosit[0],ky);
    SetAPen(rp,1);
    FOR i:=1 TO saroja DO BEGIN
        draw(rp,kx+cosit[i],ky+sinit[i]);
    END;
    draw(rp,kx+cosit[0],ky);
    SetAPen(rp,15);
    FLOOD(rp,1,kx,ky);
    SetApen(rp,1);
END;

PROCEDURE HUOM(Str:String;t:SHORT);
VAR Wst:String;
BEGIN
    Wst:=w^.Title;
    SetWindowTitles(w,Str,s^.Title);
    delay(t);
    SetWindowTitles(w,Wst,s^.Title);
END;



FUNCTION TASOPARILLINEN:BOOLEAN;
BEGIN
  TASOPARILLINEN:=(taso MOD 2=0)
END;
FUNCTION SARAKESIIRTO:BOOLEAN;
BEGIN
  IF TASOPARILLINEN THEN SARAKESIIRTO:=konesarakkeittain
                    ELSE SARAKESIIRTO:=NOT(konesarakkeittain)
END;
PROCEDURE MUUTALAUTATILANNE(siirto:indtype);
BEGIN
     pelilauta[tahtirivi,tahtisara]:=tyhja;
     IF SARAKESIIRTO THEN
        BEGIN
            pelilauta[siirto,tahtisara]:=tahti;
            tahtirivi:=siirto;
        END ELSE
            BEGIN
                pelilauta[tahtirivi,siirto]:=tahti;
                tahtisara:=siirto;
            END;
END;

PROCEDURE KONESIIRTAA;
VAR alkuind:indtype;
    pelipuu,
    uusitaso:puu;
    pojat:solmuos;
    parasind:indtype;
    Str2:String;
    l,i:INTEGER;
PROCEDURE PERULAUTATILANNE(siirto:indtype);
BEGIN
     pelilauta[tahtirivi,tahtisara]:=alkutilanne[tahtirivi,tahtisara];
     IF SARAKESIIRTO
        THEN
           BEGIN
                pelilauta[siirto,tahtisara]:=tahti;
                tahtirivi:=siirto;
           END
        ELSE
           BEGIN
                pelilauta[tahtirivi,siirto]:=tahti;
                tahtisara:=siirto;
           END;
END;
PROCEDURE TUHOATASOSOLMU(VAR os:puu);
BEGIN
  os^.ylataso:=kayttamattomat;
  kayttamattomat:=os;
END;
PROCEDURE UUSITASOSOLMU(VAR os:puu);
BEGIN
  IF kayttamattomat=NIL THEN NEW(os)
  ELSE BEGIN
         os:=kayttamattomat;
         kayttamattomat:=kayttamattomat^.ylataso;
         os^.ylataso:=NIL;
       END;
END;
PROCEDURE UUSISOLMU(VAR os:solmuos);
BEGIN
  IF kayttamattsolmut=NIL THEN NEW(os)
  ELSE
    BEGIN
      os:=kayttamattsolmut;
      kayttamattsolmut:=kayttamattsolmut^.oikveli;
      os^.oikveli:=NIL;
    END;
END;
PROCEDURE TUHOASOLMU(VAR os:solmuos);
BEGIN
  os^.oikveli:=kayttamattsolmut;
  kayttamattsolmut:=os;
END;
PROCEDURE RAKENNASEURAAVATASO;
VAR  solmu,vika:solmuos;
            ind:indtype;
     laattaarvo:INTEGER;
BEGIN
  pojat:=NIL;
  taso:=taso+1;
  FOR ind:=1 TO maxind DO
    BEGIN
      IF SARAKESIIRTO THEN laattaarvo:=pelilauta[ind,tahtisara]
       ELSE laattaarvo:=pelilauta[tahtirivi,ind];
      IF laattaarvo<>tyhja THEN
         IF laattaarvo<>tahti THEN
            BEGIN
              UUSISOLMU(solmu);
              IF TASOPARILLINEN THEN
                 solmu^.arvo:=pelipuu^.siirrot^.arvo+laattaarvo
               ELSE solmu^.arvo:=pelipuu^.siirrot^.arvo-laattaarvo;
              solmu^.ind:=ind;
              IF pojat=NIL THEN  { Vasta ensimm‰inen solmu jonoon }
                BEGIN
                  pojat:=solmu;
                  vika:=pojat;
                END
             ELSE
                BEGIN
                  vika^.oikveli:=solmu;
                  solmu^.oikveli:=NIL;
                  vika:=solmu;
                END;
            END;
       END;
       IF pojat=NIL THEN  { Ei p‰‰sty en‰‰ jatkamaan eli p‰‰dyttiin  }
          BEGIN           { lehtisolmuun, jonka arvo kerrotaan kymme- }
             taso:=taso-1;{ nell‰.                                    }
             pelipuu^.siirrot^.arvo:=pelipuu^.siirrot^.arvo*10;
          END
        ELSE
          BEGIN
            UUSITASOSOLMU(uusitaso);
            uusitaso^.ylataso:=pelipuu;
            uusitaso^.siirrot:=pojat;
            IF TASOPARILLINEN THEN uusitaso^.parasarvo:=-MAXINT
                              ELSE uusitaso^.parasarvo:=MAXINT;
            MUUTALAUTATILANNE(uusitaso^.siirrot^.ind);
            pelipuu:=uusitaso;
          END;
END;
PROCEDURE PURAPUUTA;
PROCEDURE POISTASOLMU;
VAR apusolmu:solmuos;
    arvo:Integer;
BEGIN
  arvo:=pelipuu^.siirrot^.arvo;
  IF TASOPARILLINEN THEN
     BEGIN IF arvo>pelipuu^.parasarvo THEN
          BEGIN
            pelipuu^.parasarvo:=arvo;
            IF taso=2 THEN parasind:=pelipuu^.siirrot^.ind;
          END;
     END
  ELSE
     IF arvo<pelipuu^.parasarvo THEN pelipuu^.parasarvo:=arvo;
  apusolmu:=pelipuu^.siirrot;
  pelipuu^.siirrot:=pelipuu^.siirrot^.oikveli;
  TUHOASOLMU(apusolmu);
END;
PROCEDURE NOUSETASOLTAYLOS;
VAR apu:puu;
BEGIN
  IF taso>1 THEN
  BEGIN
    pelipuu^.ylataso^.siirrot^.arvo:=pelipuu^.parasarvo;
    apu:=pelipuu;
    pelipuu:=pelipuu^.ylataso;
    TUHOATASOSOLMU(apu);
    taso:=taso-1;
    POISTASOLMU; { Poistetaan myos isasolmu }
    IF taso>1 THEN IF taso=2 THEN PERULAUTATILANNE(alkuind)
              ELSE PERULAUTATILANNE(pelipuu^.ylataso^.ylataso^.siirrot^.ind);
  END;
END;
BEGIN { purapuuta }
 IF taso=maxtaso THEN
                   BEGIN
                     WHILE pelipuu^.siirrot<>NIL DO POISTASOLMU;
                     PERULAUTATILANNE(pelipuu^.ylataso^.ylataso^.siirrot^.ind);
                     NOUSETASOLTAYLOS;
                     IF pelipuu^.siirrot<>NIL THEN
                          MUUTALAUTATILANNE(pelipuu^.siirrot^.ind);
                     pojat:=pelipuu^.siirrot;
                   END
 ELSE
   BEGIN
     IF pelipuu^.siirrot=NIL THEN
        WHILE (pelipuu^.siirrot=NIL)AND(taso>1) DO NOUSETASOLTAYLOS
     ELSE BEGIN
            POISTASOLMU;
            IF taso=2 THEN PERULAUTATILANNE(alkuind)
            ELSE PERULAUTATILANNE(pelipuu^.ylataso^.ylataso^.siirrot^.ind);
          END;
     pojat:=pelipuu^.siirrot;
     IF taso<>1 THEN IF pojat<>NIL
                        THEN MUUTALAUTATILANNE(pelipuu^.siirrot^.ind);
   END;
END;
BEGIN { konesiirtaa }

    Str2:=w^.Title;
    SetWindowTitles(w,"Amiga is thinking...",s^.Title);

     taso:=1;
     IF konesarakkeittain THEN alkuind:=tahtirivi
                          ELSE alkuind:=tahtisara;
     UUSITASOSOLMU(pelipuu);
     UUSISOLMU(pojat);
     pojat^.arvo:=koneenlaatat-pelaajanlaatat;
     IF konesarakkeittain THEN pojat^.ind:=tahtisara
                          ELSE pojat^.ind:=tahtirivi;
     pelipuu^.siirrot:=pojat;
     pelipuu^.parasarvo:=MAXINT;
     RAKENNASEURAAVATASO;
     IF pojat<>NIL THEN
        BEGIN
       
          IF pojat^.oikveli=NIL THEN parasind:=pojat^.ind
          ELSE
            WHILE taso>1 DO
                BEGIN
                  WHILE (pojat<>NIL)AND(taso<maxtaso) DO
                     RAKENNASEURAAVATASO;
                  PURAPUUTA;
                END;  {poistat‰hti}
          FBOX(edtahtirivi,edtahtisara,1,0);
          FOR i:=1 TO maxind DO   {palauta perusvarireunaan}
            IF (pelilauta[edtahtirivi,i]<>tyhja) AND (i<>edtahtisara) THEN
                BOX(edtahtirivi,i,3,1);
          TUHOATASOSOLMU(pelipuu);
          taso:=0;
     
          MUUTALAUTATILANNE(parasind);
          PIIRRATAH(tahtirivi,tahtisara);

          koneenlaatat:=koneenlaatat+alkutilanne[tahtirivi,tahtisara];
          koneenvuoro:=FALSE;

        END ELSE BEGIN
            pelipaattyi:=TRUE;
            koneyht:=koneyht-alkutilanne[tahtirivi,tahtisara];{bugin korjaus}
        END;

     TULOSTA("   ",5+26*9,13+11,9,0);
     TULOSTAN(koneenlaatat,5+26*9,13+11,9,0);

     FOR i:=1 TO maxind DO {laita ohje reunavari}
        IF (pelilauta[tahtirivi,i]<>tyhja) AND (i<>tahtisara) THEN
            BOX(tahtirivi,i,7,1);
     koneyht:=koneyht+alkutilanne[tahtirivi,tahtisara];
     TULOSTA("Total:    ",5+19*9,13+2*11,9,0);
     TULOSTAN(koneyht,5+26*9,13+2*11,9,0);

     SetWindowTitles(w,Str2,s^.Title);

END;

FUNCTION laattakelpaa(ri,sa:indtype):BOOLEAN;
BEGIN
    laattakelpaa:=(konesarakkeittain AND (ri=tahtirivi)) OR (NOT(konesarakkeittain) AND (sa=tahtisara));
END;

PROCEDURE PIIRRA; {Ikkunan kokoa on muutettu, piirret‰‰n pelilauta uudestaan}
{ Draws Window allways after the size has changed }
Var d,a    :Real;
    R,Sx,v   :SHORT;
    l,whe,wwi,x1,x2,y1,y2:   SHORT;
    laatta,i:INTEGER;
BEGIN

    whe:=w^.Height;
    wwi:=w^.Width;
    SetAPen(rp,1);
    RectFill(rp,1,1,wwi,whe);
    nkx:=((wwi-18-4)/(MAXIND+0.5));
    nky:=((whe-13-3)/(MAXIND+2));

    TULOSTA("Select from the row",5,13,11,13);
    TULOSTA("Human:    ",5,13+11,11,13);
    TULOSTAN(pelaajanlaatat,5+7*9,13+11,11,13);

    TULOSTA("The Machine:    ",5+12*9,13+11,9,0);
    TULOSTAN(koneenlaatat,5+26*9,13+11,9,0);

    TULOSTA("Total:",5,13+2*11,11,13);
    TULOSTAN(pelayht,5+7*9,13+2*11,11,13);

    TULOSTA("Total:",5+19*9,13+2*11,9,0);
    TULOSTAN(koneyht,5+26*9,13+2*11,9,0);

    d:=0.9;            {Sinit ja kosinit talteen t‰hden piirtoa varten }
    FOR i:=0 TO saroja DO BEGIN
        a:=i*2*pi/saroja;
        sinit[i]:=(d*nky/2-1)/(i MOD 2+1)*sin(a);
        cosit[i]:=(d*nkx/2-1)/(i MOD 2+1)*cos(a);
    END;

    d:=0.1;
    FOR R:=1 TO MAXIND DO BEGIN
        y1:=13+nky+(R-1)*nky;
        y2:=y1+nky;
        FOR Sx:=1 TO MAXIND DO BEGIN
            laatta:=Pelilauta[R,Sx];
            IF laatta<>tyhja THEN BEGIN

                x1:=0.25*nkx+(Sx-1)*nkx;
                x2:=x1+nkx;

                IF laatta=tahti THEN PIIRRATAH(R,Sx)
                ELSE
                    BEGIN
                        IF R=tahtirivi THEN v:=7 else v:=3;
                        BOX(R,Sx,v,1);
                        BOX(R,Sx,10,2);
                        FBOX(R,Sx,9,5);
                        l:=IntToStr(Str,laatta);
                        TULOSTA(Str,x1+nkx/2-(l/2)*11,y2-nky/2+11/2,13,9);
                END;
            END;
        END;
    END;
END;


PROCEDURE PELIVALMISTELUT;
VAR luku,num:Integer;
    ri,sa:indtype;
    parametritok:BOOLEAN;

PROCEDURE ASETAALKUTILANNE;
VAR ri,sa:Integer;
BEGIN
  FOR ri:=1 TO maxind DO
      FOR sa:=1 TO maxind DO
          BEGIN
            alkutilanne[ri,sa]:=pelilauta[ri,sa];
            IF alkutilanne[ri,sa]=tahti THEN BEGIN tahtirivi:=ri;
                                               tahtisara:=sa;
                                             END;
          END;
END;
PROCEDURE ASETAPELITILANNE;
VAR ri,sa:Integer;
BEGIN
  FOR ri:=1 TO maxind DO
      FOR sa:=1 TO maxind DO
          BEGIN
            pelilauta[ri,sa]:=alkutilanne[ri,sa];
            IF pelilauta[ri,sa]=tahti THEN BEGIN tahtirivi:=ri;
                                               tahtisara:=sa;
                                             END;
          END;
END;

PROCEDURE ARVOLAATATJAPAIKAT;
VAR r,s:indtype;
    vali,
    ran,
    seed:Integer;
BEGIN
  {seed:=INIT_SEED(0);}
  vali:=maxarvo-minarvo+1;
  FOR r:=1 TO maxind DO
    FOR s:=1 TO maxind DO
      BEGIN
        ran:=RangeRandom(Pred(vali))-ABS(minarvo);
        pelilauta[r,s]:=ran;
        alkutilanne[r,s]:=ran;
      END;
  tahtirivi:=RangeRandom(maxind-1)+1;
  tahtisara:=RangeRandom(maxind-1)+1;
  pelilauta[tahtirivi,tahtisara]:=tahti;
  alkutilanne[tahtirivi,tahtisara]:=tahti;
END;

BEGIN { pelivalmistelut }
  pelipaattyi:=FALSE;
  FOR ri:=1 TO maxind DO FOR sa:=1 TO maxind DO pelilauta[ri,sa]:=tyhja;
  koneenlaatat:=0;
  pelaajanlaatat:=0;
  CASE laudantekotapa OF
    kaikkiarvotaan: ARVOLAATATJAPAIKAT;
    vanhaalkutilanne:ASETAPELITILANNE;
  END;
  PIIRRA;
END;
PROCEDURE HAVITAROSKAT;
VAR sol,seuraava:solmuos;
    tas,seur:puu;
BEGIN
  sol:=kayttamattsolmut;
  WHILE sol<>NIL DO
     BEGIN
       seuraava:=sol^.oikveli;
       DISPOSE(sol);
       sol:=seuraava;
     END;
  tas:=kayttamattomat;
  WHILE tas<>NIL DO
     BEGIN
       seur:=tas^.ylataso;
       DISPOSE(tas);
       tas:=seur;
     END;

END;
PROCEDURE CLEANUP(str : string; err : Integer);
BEGIN
    FreeRemember(UsedMemory,TRUE);
    IF MenuStrip <> NIL THEN BEGIN
       ClearMenuStrip(w);
       FreeMenus(MenuStrip);
    END;
    IF Str<>NIL THEN FreeString(Str);
    IF vi <> NIL THEN FreeVisualInfo(vi);
    IF w <> NIL THEN CloseWindow(w);
    IF MyTmpRasPtr<>NIL THEN FreeRaster(MyTmpRasPTR,sx,sy);
    IF GadToolsBase <> NIL THEN CloseLibrary(GadToolsBase);
    HAVITAROSKAT;
    Exit(err);
END;

{ Annetaan globaaleille muuttujille oletusarvoiset alkuarvot }


{ N‰it‰ voisi periaatteessa muuttaa ajon aikana, mutta en ole viel‰ saannut
  aikaiseksi tehty‰ Gadtools proceduureja }


PROCEDURE ALKUVALMISTELUT;
VAR ri,sa:Integer;
BEGIN
  MAXIND:=6;
  koneenvuoro:=FALSE;      pelipaattyi:=FALSE;    konesarakkeittain:=TRUE;
  laudantekotapa:=kaikkiarvotaan;                 maxtaso:=8;
  kayttamattomat:=NIL;    kayttamattsolmut:=NIL;
  maxarvo:=15;            minarvo:=-15;
  edtahtirivi:=tahtirivi; edtahtisara:=tahtisara;

  FOR ri:=1 TO maxind DO FOR sa:=1 TO maxind DO
      BEGIN alkutilanne[ri,sa]:=tyhja; pelilauta[ri,sa]:=tyhja; END;
  SelfSeed;
END;

PROCEDURE SETUP;
VAR
    i   : Short;
    p   : Byte;
BEGIN
    UsedMemory := Nil;
    GadToolsBase := OpenLibrary("gadtools.library",37);

    IF GadToolsBase = NIL then CleanUp("Can't open gadtools,library",20);

    w := OpenWindow(@nw);            { open a window }

    vi := GetVisualInfo(w^.WScreen, TAG_END);
    IF vi = NIL then CleanUp("No visual info",10);
    

    IF OSVersion >= 39 then MenuStrip := CreateMenus(adr(nm),GTMN_FrontPen,1,TAG_END)
    else MenuStrip := CreateMenus(adr(nm),TAG_END);

    s:=w^.Wscreen;
    sx:=s^.Width;
    sy:=s^.Height;

    IF MenuStrip = NIL then CleanUp("Could not open Menus",10);
    IF LayoutMenus(MenuStrip,vi,TAG_END)=false then
        CleanUp("Could not layout Menus",10);
    IF SetMenuStrip(w, MenuStrip) = false then
        CleanUp("Could not set the Menus",10);
    Str:=AllocString(20);

    rp := w^.RPort;
    TopazFont:=OpenFont(adr(MyTextAttr));
    If TopazFont=NIL then Cleanup(NIL,10);
    SetFont(rp,TopazFont);
  
    MytmprasPtr:=AllocRaster(sx,sy);
    InitTmpRas(@Mytmpras,MytmprasPtr,RASSIZE(sx,sy));
    rp^.TmpRas:=@MyTmpRas;
END;

PROCEDURE PROCESSALUE;
VAR OnAlue:BOOLEAN;
    ri,sa,i:Indtype;
    mx,my,x1,x2,y1,y2,laatta,l:INTEGER;

PROCEDURE TARKISTAVIELA;
BEGIN
    laatta:=pelilauta[ri,sa];
    CASE laatta OF
        tahti   : HUOM("You can't remove the Star",50);
        tyhja   : HUOM("You can't remove emptyness",20);
        ELSE
            BEGIN
                pelaajanlaatat:=pelaajanlaatat+pelilauta[ri,sa];
                FBOX(tahtirivi,tahtisara,1,0);
                {poista valkoiset kehykset}
                FOR i:=1 TO maxind DO BEGIN
                    IF (pelilauta[tahtirivi,i]<>tyhja) AND (pelilauta[tahtirivi,i]<>tahti) THEN
                        BOX(tahtirivi,i,3,1);
                END;
                pelilauta[tahtirivi,tahtisara]:=tyhja;
                tahtirivi:=ri;
                tahtisara:=sa;
                PIIRRATAH(ri,sa);
                pelilauta[ri,sa]:=tahti;
                koneenvuoro:=TRUE;
                TULOSTA("   ",5+7*9,13+11,11,13);
                TULOSTAN(pelaajanlaatat,5+7*9,13+11,11,13);
                edtahtirivi:=tahtirivi;
                edtahtisara:=tahtisara;

                pelayht:=pelayht+laatta;
                TULOSTA("Total:    ",5,13+2*11,11,13);
                TULOSTAN(pelayht,5+7*9,13+2*11,11,13);

            END;
    END;

END;
BEGIN   { PROCESSALUE Tutkitaan onko ja mill‰ laatalla }
    ri:=1; sa:=1;
    mx:=IPtr^.MouseX;
    my:=IPtr^.MouseY;
    REPEAT
        OnAlue:=(my>26+ri*nky) AND( my<26+(ri+1)*nky) AND (mx>3+(sa-0.75)*nkx) AND (mx<3+(sa+0.25)*nkx);
        IF NOT OnAlue THEN BEGIN
            sa:=sa+1; IF sa=MAXIND+1 THEN BEGIN ri:=ri+1; sa:=1; END;
        END;
    UNTIL Onalue OR (ri>MAXIND);

    IF Onalue AND laattakelpaa(ri,sa) THEN
        TARKISTAVIELA
    ELSE
        HUOM("Not in a row",40);
END;


PROCEDURE PROCESSMENU;
VAR ItemNumber:SHORT;
BEGIN
   ItemNumber := ItemNum(IPtr^.Code);
   CASE ItemNumber OF
       0: pelivalmistelut;
       1: HUOM("Not yet working",50);
       2:quit:=TRUE;
   END;
END;
BEGIN
    SETUP;
    ALKUVALMISTELUT;
    REPEAT
        PELIVALMISTELUT;
        REPEAT
            IF koneenvuoro THEN KONESIIRTAA;
            IPtr := IntuiMessagePtr(WaitPort(w^.UserPort));
            IPtr := IntuiMessagePtr(GetMsg(w^.UserPort));
            CASE IPtr^.Class OF
                IDCMP_CLOSEWINDOW : quit:= TRUE;
                IDCMP_NEWSIZE     : PIIRRA;
                IDCMP_MENUPICK    : PROCESSMENU;
                IDCMP_MOUSEBUTTONS: IF (NOT koneenvuoro) AND (Iptr^.Code=SELECTDOWN) THEN BEGIN
                    PROCESSALUE;
                END;
            END;
            ReplyMsg(MessagePtr(IPtr));
         UNTIL pelipaattyi OR quit;

         IF pelipaattyi THEN
            IF (pelaajanlaatat>koneenlaatat) THEN HUOM("Ouh Yeah! You Win!!",200)
            ELSE HUOM("You lost again...",100);

    UNTIL quit;
    CLEANUP(NIL,0);
END.


