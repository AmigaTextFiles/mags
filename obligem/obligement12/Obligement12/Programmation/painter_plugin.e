-> Example de plugin pour EasyGUI : Un Painter.
-> olivieradam@minitel.net (ASCII only ! )

OPT MODULE       ->ceci est un module
OPT OSVERSION=37 ->version minimum du système


      ->modules                 objets , CONSTANTES
MODULE 'graphics/text',       ->textattr
       'intuition/intuition', ->window,intuimessage
       'intuition/screens',   ->screen
       'tools/EasyGUI'        ->plugin , PLUGIN

      ->notre objet : une surface pouvant être peinte
EXPORT OBJECT painter OF plugin
  xm:INT,   ->x souris
  ym:INT,   ->y souris
  color:INT ->couleur choisie
ENDOBJECT

EXPORT CONST PAINTER=PLUGIN


      ->Les méthodes par défaut :

PROC will_resize() OF painter IS RESIZEX OR RESIZEY

PROC min_size(ta:PTR TO textattr,fh) OF painter IS 100,100 ->taille de 100*100

PROC render(ta:PTR TO textattr,x,y,xs,ys,w:PTR TO window) OF painter IS self.draw(w,0)

PROC message_test(imsg:PTR TO intuimessage,w:PTR TO window) OF painter
   ->test automatique de l'interface
  DEF x,y
  IF (imsg.class=IDCMP_MOUSEBUTTONS) OR (imsg.code=SELECTUP) ->si on a cliqué alors:
    x:=imsg.mousex
    y:=imsg.mousey
    IF (x>=self.x) AND (y>=self.y) AND (x<(self.x+self.xs)) AND (y<(self.y+self.ys))
    ->et si en plus on a cliqué dans la fenêtre alors :
      self.xm:=x-self.x*1000/self.xs    ->changement d'échelle
      self.ym:=y-self.y*1000/self.ys
      RETURN TRUE  -> retourne vrai => provoque message_action()
    ENDIF
  ENDIF
ENDPROC FALSE      -> retourne faux => pas de message_action()


->ici on peut extraire les touches appuyées aussi ex Amiga Alt Ctrl Help ...
PROC message_action(class,qual,code,w:PTR TO window) OF painter
  self.draw(w,0)->dessine l'outil 0 où l'on a cliqué
ENDPROC FALSE

      ->méthode perso de dessin
PROC draw(w:PTR TO window,pad) OF painter
  DEF xm,ym          ->      \_ le pad est là pour permettre de rajouter des outils
  SELECT pad
     CASE 0
        xm:=self.xm*self.xs/1000+self.x       ->re-changement d'échelle
        ym:=self.ym*self.ys/1000+self.y
        SetStdRast(w.rport)                 ->des fois que ...
        ->ma petite brosse
        Line(xm-1,ym,xm+1,ym,self.color)
        Line(xm,ym+1,xm,ym-1,self.color)
        Plot(self.xm+self.x,self.ym+self.y,self.color)
   ->CASE 1 ->autre outil, par exemple : ligne, rond, rectangle...
     DEFAULT ; NOP -> outil par défaut, pour ne rien oublier
  ENDSELECT
ENDPROC

