->painter.e pour Obligement
->©Adam98

OPT OSVERSION=37        ->blue-box : B1230-IV@50
OPT PREPROCESS               

MODULE 'graphics/text',      
       'intuition/intuition',
       'intuition/screens',
       'tools/EasyGUI',
       'tools/exceptions',->gestion des erreurs
       '*mousemove',
       '*painter_plugin', ->retaillage modifié ! n'oubliez pas de le recompiler
       '*painter_rev'     

->globales
DEF f_prems:PTR TO guihandle,
    f_deuzz:PTR TO guihandle,
    plug:PTR TO painter
   

->programme
PROC main() HANDLE
->locales
  DEF depth,
      di:PTR TO drawinfo,
      mh=NIL,
      mouse:PTR TO mousemove,
      s:PTR TO screen

    s:=LockPubScreen(NIL)     
      di:=GetScreenDrawInfo(s) 
        depth:=di.depth        
      FreeScreenDrawInfo(s,di) 
    UnlockPubScreen(NIL,s)   

-> l'interface multi-fenêtrée !!!
  mh:=multiinit()   ->initialisation de mh

-> première fenêtre
  f_prems:=addmultiA(mh,VERSION_INFO,
    NEW [EQROWS,
          [PLUGIN,{m_a}, NEW mouse],
      NEW [BEVEL,
          [PAINTER,0,NEW plug]
          ]
        ],NIL)
plug.color:=1
-> deuxième fenêtre
  f_deuzz:=addmultiA(mh,' ',
    NEW [PALETTE,{p_a},NIL,depth,3,8,plug.color],
        [EG_WTYPE,WTYPE_NOSIZE,
         EG_CLOSE,{close},
         EG_TOP,f_prems.wnd.topedge,
         EG_LEFT,(5+f_prems.wnd.leftedge+f_prems.wnd.width),
         NIL])

->gestion des fenêtres très sommaire...
  multiloop(mh)

EXCEPT DO   
  cleanmulti(mh)      ->fait tout pour nous
  report_exception()  ->nous dit tout
ENDPROC

PROC close(mh:PTR TO multihandle,info) IS closewin(info)

PROC p_a(info,col)
plug.color:=col
ENDPROC

PROC m_a(info)
   IF f_deuzz<>0 THEN movewin(f_deuzz,(5+f_prems.wnd.leftedge+f_prems.wnd.width),f_prems.wnd.topedge)
ENDPROC

