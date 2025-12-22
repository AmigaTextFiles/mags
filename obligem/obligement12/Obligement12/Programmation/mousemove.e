->mousemove-plugin
OPT MODULE
OPT OSVERSION=37
OPT EXPORT

MODULE 'tools/EasyGUI',
       'intuition/intuition'

OBJECT mousemove OF plugin
   mx,old_mx
   my,old_my
ENDOBJECT

PROC min_size(ta,fh) OF mousemove IS 0,0

PROC will_resize() OF mousemove IS FALSE

PROC render(ta,x,y,xs,ys,w:PTR TO window) OF mousemove IS EMPTY

PROC message_test(imsg:PTR TO intuimessage,w:PTR TO window) OF mousemove
   self.mx:=imsg.mousex
   self.my:=imsg.mousey
   self.old_mx:=self.mx
   self.old_my:=self.my
ENDPROC imsg.class=IDCMP_INTUITICKS

PROC message_action(class,qual,code,win) OF mousemove IS TRUE
