/*=====Datumsausgabe mit Begrüßung=====*/
Datum=date(s) ; Tag=date(w)  ; Zeit=Time(n)
T=1*right(Datum,2) ; MNr = substr(Datum,5,2) ; J=left(Datum,4)
Stunde = left(Zeit,2)
Monate = "Januar Februar März April Mai Juni Juli August
 September Oktober November Dezember"
TageE = "Monday Tuesday Wednesday Thursday Friday Saturday Sunday"
TageD = "Montag Dienstag Mittwoch Donnerstag Freitag Samstag Sonntag"
if Stunde >=0 & Stunde <=3 then Begr=" Hi, so spät noch aktiv ???"
if Stunde >3 & Stunde <=6 then Begr=" So früh am Computer?Geh lieber ins Bett !"
if Stunde >6 & Stunde <=8 then Begr=" Guten Morgen so früh schon auf?"
if Stunde >8 & Stunde <=12 then Begr=" Guten Morgen."
if Stunde >12 & Stunde <=18 then Begr=" Guten Tag."
if Stunde >18 & Stunde <=23 then Begr=" Guten Abend."
if MNr = 12 & T = 31 then Begr="Ich wünsche eine feuchtfröhliche Silvester-Party!"
if MNr = 01 & T = 1 then Begr="Ich wünsche ein frohes neues Jahr."
if MNr = 12 & T = 24 then Begr="Frohe Weihnachten alle!"
if MNr = 04 & T =9 then Begr="Funktioniert´s???"
MonatName = word(Monate,MNr)
TNr = find(TageE,Tag)
Tag = word(TageD,TNr)
say "  "; say Begr; say " "
say " Heute ist "Tag" der "T". "MonatName" "J".Es ist "left(Zeit,5)" Uhr"
DO i=1 TO 1000
end
exit



