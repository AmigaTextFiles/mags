/* ==========  AslFile1.rexx ==========
    Einfacher MultiFileRequester mit
    ALLOCFILEREQUEST() u. REQUESTFILE() */
/* Externe Bibliotheken einbinden */
if(~show('l','rexxsupport.library'))
then call addlib('rexxsupport.library',0,-30,0)
if(~show('l','apig.library'))
then call addlib('apig.library',0,-30,0)
/* Requester-Struktur anlegen */
 freq = ALLOCFILEREQUEST()
/* Parameter für REQUESTFILE */
 multi = 1 /* Mehrfachauswahl möglich */
 save = 0
 hail = "MultiFileRequester"
 dir  = "RAM:" /* voreingest. Verzeichnis */
 file = ""  /* voreingest. Filename */
 pat  = 1   /* Wenn pat > 0 :Pattern-Gadget */
 nofile = 0 /* nofile > 0: nur Verzeichnisse */
 win = null() /* Zeiger auf Parentwindow */
 x   = 0      /* linke obere Ecke */
 y   = 0
 wid = 500    /* Requester-Breite */ 
 hgt = 190    /* Requester-Höhe  */
 sep = '0a20'x /* Separator bei Mehrfachauswahl */
/* Requester aufrufen */
filename = REQUESTFILE(freq,multi,save,hail,dir,file,pat,nofile,win,x,y,wid,hgt,sep)
/* Ergebnis auswerten */
if filename = null()
   then say "Cancel angeklickt!"
   else do
     say " Angeklickt wurde:" '0a'x
     say "" filename
     end
/* Aufräumen */
call FREEFILEREQUEST(freq)
/*
 call remlib('rexxsupport.library')
 call remlib('apig.library')
 address COMMAND 'avail >NIL: flush'
*/

