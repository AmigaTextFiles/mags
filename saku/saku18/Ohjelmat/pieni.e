
PROC main()
  DEF x[10]: ARRAY OF LONG,
      s[20]:STRING,  /* apumuuttuja reaalilukujen tulostukseen */
      x0=0.0,  /* alkuarvo Huom! desimaalipiste on oltava nollassakin*/
      ind=0,   /* sarjan alkion indeksi (t‰m‰ on 16-bit kokonaisluku) */
      i, j,    /* taulukkojen k‰sittelyyn */
      q=0.1,   /* samoin t‰ss‰ on oltava "."(vaikka arvo olisi 1.0) */
      samoja,  /* totuusarvo samojen lˆytymiselle 10 joukosta */
      pot=10   /* apumuutuja tulostuksen hallintaan */

  WriteF('Rekursiokaava x:=1-qxx, miss‰ x[0]=\s ',RealF(s,!x0,8))
  WriteF('ja q=\s\n',RealF(s,!q,8))

  REPEAT
    FOR i:=0 TO 9         /* lasketaan kymmenen kerralla */
      x[i]:=!1.0-(!q*x0*x0)
      x0:=x[i]
      INC ind
    ENDFOR
    i:=0                  /* tarkastetaan lˆytyikˆ niiden joukosta */
    REPEAT                /* samoja */
      j:=i+1
      REPEAT
         samoja:=(!x[i]=x[j])
         INC j
      UNTIL (j=9) OR samoja
      INC i
    UNTIL (i=8) OR samoja
                          /* tulostetaan jos samoja lˆytyi tai */
                          /* ind-10 on jaollinen 10^pot:lla */
    IF samoja OR (Mod(ind-10,pot)=0)
      FOR i:=0 TO 9
        WriteF('x[\d] =  \s\n',ind+i-9,RealF(s,x[i],8))
      ENDFOR
      pot:=10*pot
    ENDIF
    x0:=x[9]   /* asetetaan uusi x0 ja jos ei paineta hiirt‰, niin */
  UNTIL (ind>650000) OR samoja OR (Mouse()=1) /* toistetaan kunnes...*/
  WriteF('Ohjelma p‰‰ttyi.')
ENDPROC
