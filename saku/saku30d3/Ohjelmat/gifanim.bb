
;Ohjelma jolla voi tuottaa erivaiheisia iff kuvia RAM:hakemistoon
; Tekee myˆs skriptin, jolla kuvat voi muuttaa gif-formaattiin
; ja animaatioksi, GfxCon ja WhirlGif ohjelmia k‰ytt‰en.

dir$="RAM:"  ;tyˆhakemisto

If NumPars>0
   p=Val(Par$(1))
   If p<>1 AND p<>2 Then NPrint "V‰‰r‰ parametri. Arvot 1 tai 2":p=1
Else
   p=1
EndIf

maxx=100     ;Tehd‰‰n pieni‰ 100x100 kuvia
maxy=100
x0=maxx/2
y0=maxy/2
mv=8         ;v‰rej‰ 8
maxvaihe=8
Screen 0,0,0,320,256,3,$0,T$,1,0
PalRGB 0,0,0,0,0
PalRGB 0,1,15,15,0
PalRGB 0,2,7,8,0
PalRGB 0,3,15,0,0
PalRGB 0,4,15,10,0
PalRGB 0,5,0,4,8
PalRGB 0,6,15,6,0
PalRGB 0,7,8,13,15
Use Palette 0
BitMap 0,maxx,maxy,3
ScreensBitMap 0,0

;P‰‰luuppi, josta hypit‰‰n p:n arvon perusteella joko Animaatio1:een tai 2:een
For vaihe=1 To maxvaihe
   If p=1 Gosub Animaatio1
   If p=2 Gosub Animaatio2
   nimi$=dir$+"kuva"+Str$(vaihe)+".iff"
   GetaShape 0,0,0,maxx,maxy
   SaveShape 0,nimi$,0
Next vaihe
;************************************************************
;Tehd‰‰n skripti jolla muutetaan kuvat giffeksi
FileOutput 1
e=WriteFile(1,dir$+"make")
NPrint " Stack 20000"
For vaihe=1 To maxvaihe
   nimi$=dir$+"kuva"+Str$(vaihe)+".iff"
   NPrint " GfxCon ",nimi$," Format GIF"
Next vaihe
;************************************************************
;lis‰t‰‰n siihen k‰skyt, jolla tehd‰‰n gif-animaatio
Print "WhirlGif -o anim.gif -loop "
For vaihe=1 To maxvaihe
   nimi$=dir$+"kuva"+Str$(vaihe)
   Print nimi$,".gif "
Next vaihe
NPrint " "
NPrint "echo ",Chr$(34),"Animaatio valmis",Chr$(34)
DefaultOutput
NPrint "K‰ynnist‰(execute) RAM:make skripti"
CloseFile 1
End
;************************************************************
Animaatio1      ; Spiraalit, ulosp‰in laajeneva keh‰
; oleellinen parametri (globaali muuttuja) on vaihe, joka parametroi vaiheen 1...maxvaihe
;Ohjelma k‰ytt‰‰ t‰t‰t saadessaan parametri 1 syˆtteeksi (oletusarvo)
Cls(0)
r=1                         ;kasvava s‰de
dr=0.004
v=1                         ;v‰ri
a=(vaihe-1)*Pi/maxvaihe     ;kulman alkuarvo (riippuu vaiheesta)
das=Pi/maxvaihe             ;kulman kasvu
Line x0,y0,x0,y0,0
Repeat
   x=x0+Cos(a)*r
   y=y0+Sin(a)*r
   Line x,y,v MOD (mv-1)
   r=r+dr
   dr=r/(r^1.1*10)
   v=v+1
   a=a+das+dr
Until (x<0 AND y<0) OR dr<0.005
Return
;************************************************************
Animaatio2     ;L‰hestyv‰t neliˆt
; oleellinen parametri on vaihe(globaali muuttuja), joka parametroi vaiheen 1...maxvaihe
; Ohjelma k‰ytt‰‰ t‰t‰ saadessaan parametri 2 syˆtteeksi
Cls(5)
k=1.15    ;kerroin
vlkm=2     ;k‰ytettyjen v‰rien lukum‰‰r‰
kk=k^(maxvaihe/vlkm)
lev=2      ;neliˆn leveys
kor=2      ;Neliiˆn korkeus
px=0.11    ;Neliˆn paksuus
py=0.65
n=1
Repeat
   If n MOD (maxvaihe)+1=vaihe
      alev=lev
      apx=px
      akor=kor
      For v=1 To vlkm
         For ppx=0 To apx
            Box x0-alev/2+ppx,y0-akor/2+py*ppx,x0+alev/2-ppx,y0+akor/2-py*ppx,v
         Next ppx
         alev=alev*kk
         apx=apx*kk
         akor=akor*kk
      Next v
   EndIf
   lev=lev*k
   px=px*k
   kor=kor*k
   n=n+1
Until lev>2*maxx
Return
;************************************************************
Animaatio3
   ;Viel‰ puuttuu
Return
