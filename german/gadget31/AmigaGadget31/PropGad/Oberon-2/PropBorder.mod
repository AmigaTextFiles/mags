(********************************************************************
:Program.     PropBorder.mod
:Contents.    Bindet ein Proportional-Gadget in den rechten Windowrand ein
:Contents.    und gibt die aktuelle Position des Gadget(PGA_TOP) im
:Contents.    Shell-Window aus.
:Contents.    (Beschreibung siehe AmigaGadget #27, Programmieren /
:Contents.     Proportionalgadget mit BOOPSI, Jürgen Klawitter)
:Copyright.   (c) 1996 Sven Drieling
:Language.    Oberon-2
:Translator.  A+L Amiga Oberon Compiler V3.11d
:History.     V1.0  indy 25-Jun-97
:Imports.     Oberon_Interfaces 3.6 (12.1.95)
*********************************************************************)

MODULE PropBorder;

IMPORT
  io,
  e: Exec,
  i: Intuition,
  u: Utility,
  s: SYSTEM;

CONST
  Vers = "\o$VER: PropGadget in Border 1.0";
  PropGadgetID    =  1;
  MinWindowWidth  = 50;
  MinWindowHeight = 50;

VAR
  vers   : e.STRING;
  w      : i.WindowPtr;
  msg    : i.IntuiMessagePtr;
  prop,
  sizeGad: i.GadgetPtr;

  done   : BOOLEAN;
  sizeHeight,             (* Höhe des Sizing-Gadgets                 *)
  lock,                   (* Intuition locken                        *)
  top,                    (* PGA_TOP auslesen                        *)
  dummy      : LONGINT;
(**********************************************************)

PROCEDURE FindSysGadget(w: i.WindowPtr; gadType: INTEGER): i.GadgetPtr;

(*
  Sucht die Gadget-Liste eines Windows durch und liefert den Zeiger
  auf das erste Gadget zurück bei dem g->GadgetType & gadType != NULL ist.
  Falls das Gadget nicht gefunden wird, wird NULL zurückgegeben.
*)

VAR
  g: i.GadgetPtr;

BEGIN
  IF w # NIL THEN
    g:= w.firstGadget;

    WHILE g # NIL DO
      IF (s.VAL(SET, g.gadgetType) * s.VAL(SET, gadType)) # {} THEN (* AND *)
        RETURN(g);
      ELSE
        g:= g.nextGadget;
      END;
    END;
  END;

  RETURN(g);
END FindSysGadget;
(**********************************************************)

BEGIN
  vers:= Vers;  (* Vermeidet Wegoptimierung *)

  w:= i.OpenWindowTagsA(NIL,
        i.waTitle    , s.ADR("PropGadget in Border 1.0"),
        i.waFlags    , LONGSET{i.windowDepth, i.windowDrag, i.windowClose,
                             i.windowSizing},
        i.waIDCMP    , LONGSET{i.closeWindow, i.idcmpUpdate},
        i.waMinWidth , MinWindowWidth,
        i.waMinHeight, MinWindowHeight,
        u.end);

  IF w # NIL THEN
    (* Höhe des Sizing-Gadgets ermitteln *)
    lock:= i.LockIBase(0);
    sizeGad:= FindSysGadget(w, i.sizing);
    IF sizeGad # NIL THEN sizeHeight:= sizeGad.height; END;
    i.UnlockIBase(lock);

    (* PropGadget erstellen *)
    prop:= i.NewObject(NIL, "propgclass",
              i.gaID,           PropGadgetID,
              i.gaTop,          w.borderTop + 1,
              i.gaWidth,        w.borderRight - 6,
              i.gaRelRight,     -(w.borderRight - 3),
              i.gaRelHeight,    -(w.borderTop + sizeHeight + 1),
              i.gaRightBorder,  e.true,
              i.icaTarget,      i.icTargetIDCMP,
              i.pgaFreedom,     LONGSET{i.freeVert},
              i.pgaNewLook,     e.true,
              i.pgaBorderless,  e.true,
              i.pgaVisible,      10,
              i.pgaTotal,       100,
              i.pgaTop,         0,
              u.end);

    IF prop # NIL THEN
      dummy:= i.AddGList(w, prop, -1, -1, NIL); (* Gadget(s) dem Window hinzufügen *)
      i.RefreshGList(prop, w, NIL, -1);         (* Gadget(s) anzeigen              *)

      WHILE done = FALSE DO

        e.WaitPort(w.userPort);
        msg:= e.GetMsg(w.userPort);

        WHILE msg # NIL DO

          IF i.closeWindow IN msg.class THEN
            done:= TRUE;
          END;

          IF i.idcmpUpdate IN msg.class THEN
            dummy:= i.GetAttr(i.pgaTop, prop, top);
            io.WriteString("PGA_TOP = "); io.WriteInt(top, 1); io.WriteLn;
          END;

          e.ReplyMsg(msg);
          msg:= e.GetMsg(w.userPort);
        END;
      END;

      dummy:= i.RemoveGList(w, prop, -1); (* Gadget(s) wieder entfernen *)
      i.DisposeObject(prop);
    END;

    i.CloseWindow(w);
  END;
END PropBorder.
