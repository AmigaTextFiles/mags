/* ==========  Draw.rexx ========== */

/* Externe Funktionsbibliotheken einbinden */
if(~show('l','rexxsupport.library'))
  then call addlib('rexxsupport.library',0,-30,0)
if(~show('l','apig.library'))
  then call addlib('apig.library',0,-30,0)
if(~show('l','rexxmathlib.library'))
  then call addlib('rexxmathlib.library',0,-30,0)

call set_apig_globals()

/* Messageport anlegen */
portname = "msgport"
call openport(portname)
WaitForPort portname

/* Einen HiRes-Screen mit 16 Farben öffenen */
scrtitle = " Das ist ein CUSTOMSCREEN ..."
scr = openscreen(0,0,640,256,4,2,1,HIRES,CUSTOMSCREEN,scrtitle)
call delay(50)

/* Fenster öffnen */
wtitle = "... hier ist das Fenster dazu! (Abbruch mit CLOSE-Gadget)"
widcmp = CLOSEWINDOW
wflags = WINDOWCLOSE+WINDOWDRAG+WINDOWDEPTH+GIMMEZEROZERO+ACTIVATE
win = openwindow(portname,0,0,640,256,2,0,widcmp,wflags,wtitle,scr,0,0,0)
winrastport = getwindowrastport(win)

/* Hintergrundfarbe #1 (schwarz) */
call setbpen(winrastport,1)
call clearscreen(winrastport,0,0)

/* Linienbündel zeichnen */
exitme=0
do forever
   n=random(10,20)
   do for 12
   x1=random(10,320);x2=random(320,600)
   y1=random(10,220);y2=random(50,220)
   dx=random(2,6);   dy=random(2,6)
   p = random(1,15)
   if randu <.5 then dx=-dx
   do j=1 to n
     call setapen(winrastport,p)
     call move(winrastport,x1,y1)
     call draw(winrastport,x2,y2)
     x1=x1+dx;x2=x2+dx
     y1=y1+dy;y2=y2-dy
   end
   end
      call delay(100)
      call clearscreen(winrastport,0,0)
      do i = 1 to n
       x  = random(10,500)
       y  = random(10,160)
       x2 = random(x+10,620)
       y2 = random(y+10,240)
       p  = random(1,15)
       call setapen(winrastport,p)
       call rectfill(winrastport,x,y,x2,y2)
      end
      call delay(150)
      call clearscreen(winrastport,0,0)
   /* CLOSE-Gadget angeklickt? */
   msg = getpkt(portname)
   if msg ~= '0000 0000'x then do
    class = getarg(msg,0)
    if class = CLOSEWINDOW then exitme = 1
    call reply(msg,0)
   end
   if exitme = 1 then leave
end

/* Cleanup */
call closewindow(win)
call closescreen(scr)
 /*
 call remlib('rexxsupport.library')
 call remlib('apig.library')
 address COMMAND 'avail >NIL: flush'
 */
