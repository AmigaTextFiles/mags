(********************************************************************
:Program.     PropBorderTxt.mod
:Contents.    Bindet ein Proportional-Gadget in den rechten Windowrand ein.
:Contents.    Lädt den als erstes Argument angebenen Text und zeigt ihn
:Contents.    abhängig von der Position des Prop-Gadgets im Window an.
:Copyright.   (c) 1996 Sven Drieling
:Language.    Oberon-2
:Translator.  A+L Amiga Oberon Compiler V3.11d
:History.     V1.0  indy 25-Jun-97
:Imports.     Oberon_Interfaces 3.6 (12.1.95)
*********************************************************************)

MODULE PropBorderTxt;

IMPORT
  args: Arguments,

    io,
    fs: FileSystem,
     l: LinkedLists,
   STR: STRING,

     e: Exec,
     g: Graphics,
     i: Intuition,
     u: Utility,
     s: SYSTEM;

CONST
  Vers = "\o$VER: PropGadget in Border Text 1.0";
  PropGadgetID    =  1;
  MinWindowWidth  = 50;
  MinWindowHeight = 50;

TYPE
  InnerWindowPtr = POINTER TO InnerWindow;
  InnerWindow    = RECORD
    minX, minY, maxX, maxY, width, height: INTEGER;
  END;

  TextNode        = POINTER TO TextNodeDesc;
  TextNodeDesc    = RECORD(l.NodeDesc)
                      line: STR.STRING;
                    END;
VAR
  vers   : e.STRING;
  w      : i.WindowPtr;
  drInfo : i.DrawInfoPtr; (* Enthält Pens etc.                       *)
  msg    : i.IntuiMessagePtr;
  prop,
  sizeGad: i.GadgetPtr;
  iw     : InnerWindow;

  done   : BOOLEAN;
  sizeHeight,             (* Höhe des Sizing-Gadgets                 *)
  lock,                   (* Intuition locken                        *)
  top,                    (* PGA_TOP auslesen                        *)
  numLines,               (* Anzahl der Zeilen des Textes            *)
  visibleLines,           (* Anzahl der im Fenster sichtbaren Zeilen *)
  dummy  : LONGINT;

  txt    : l.List;        (* Text, jede Node ist eine Zeile          *)
  argv   : ARRAY 2 OF e.STRING; (* Vorsicht maximal 255 Zeichen als
                                   Argument möglich! *)
(**********************************************************)

PROCEDURE GetInnerWindow(w: i.WindowPtr; VAR iw: InnerWindow);
(*
   Ermittelt die Größe und die Position des inneren Windows(Window ohne
   Rahmen).
*)

BEGIN
  IF w # NIL THEN
    iw.minX   := w.borderLeft;
    iw.minY   := w.borderTop;
    iw.maxX   := w.width  - w.borderRight - 1;
    iw.maxY   := w.height - w.borderBottom - 1;
    iw.width  := iw.maxX  - iw.minX + 1;
    iw.height := iw.maxY  - iw.minY + 1;
  END;
END  GetInnerWindow;
(**********************************************************)

PROCEDURE FreeText();

BEGIN
  txt:= NIL;  (* Garbage Collector Speicherfreigabe überlassen *)
END FreeText;
(**********************************************************)

PROCEDURE ReadText(fileName: ARRAY OF CHAR): BOOLEAN;

(*
   Lädt den mittels Filenamen eingebenen Text. Dabei wird in der Exec-Liste
   "txt" für jede Zeile eine Node angelegt. Die maximale Zeilenlänge
   ist auf 1024 Zeilen begrenzt, um das einlesen des Textes einfacher zu
   gestalten. Die Liste selbst verwaltet die Länge des Textzeilen
   dynamisch. Außerdem werden in numLines die Anzahl der Zeilen gezählt.
*)

VAR
  textNode: TextNode;
  error   : BOOLEAN;
  file    : fs.File;

BEGIN
  numLines:= 0;
  NEW(txt); txt.Init();  (* Liste initialisieren *)
  IF fs.Open(file, fileName, FALSE) = TRUE THEN

    WHILE (file.status # fs.eof) AND (file.status = fs.ok) DO
      (* Zeile einlesen, Länge unbegrenzt *)
      IF fs.ReadLongString(file) = TRUE THEN
        NEW(textNode);
        textNode.line:= STR.CreateString(file.string^);
        txt.AddTail(textNode);
        INC(numLines);
      END;
    END;

    (* Falls Schleifenende durch Ende des Files error auf FALSE setzen *)
    IF file.status = fs.eof THEN error:= FALSE ELSE error:= TRUE; END;
    IF fs.Close(file) THEN END;
  END;

  IF error = TRUE THEN
    FreeText();
    RETURN(FALSE);
  ELSE
    RETURN(TRUE);
  END;
END ReadText;
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

PROCEDURE PrintPage(firstLine: LONGINT);
(*
   Gibt den Text ab der Zeile firstLine im Fenster aus. Erste Zeile = 0.
   firstLine muß eine gültige Zeile angeben, durch das richtig
   initialisierte Prop-Gadget wird dies sichergestellt.
*)

VAR
  cnt   : LONGINT;
  te    : g.Textextent;
  node  : TextNode;

BEGIN
  (* Liste bis zur ersten anzuzeigenden Zeile durchgehen *)
  node:= txt.head(TextNode);

  FOR cnt:= 0 TO firstLine -1 DO
    IF node # NIL THEN node:= node.next(TextNode) END;
  END;

  (* Window-Inhalt löschen *)
  g.EraseRect(w.rPort, iw.minX, iw.minY, iw.maxX, iw.maxY);

  (*
     Inhalt der sichtbaren Zeilen ausgeben. TextFit() berechnet wieviel
     Zeichen in eine Textzeile passen.
  *)
  cnt:= 0;
  WHILE (cnt < visibleLines) AND (node # NIL) DO
    g.Move(w.rPort, iw.minX, SHORT(iw.minY + cnt * w.rPort.txHeight +
                               w.rPort.txBaseline));

    g.Text(w.rPort, node.line.chars^,
      g.TextFit(w.rPort, node.line.chars^, node.line.Count(),
               s.ADR(te), NIL, 1, iw.width + 1, iw.height));

    INC(cnt);
    node:= node.next(TextNode);
  END;
END PrintPage;
(**********************************************************)

BEGIN
  vers:= Vers;  (* Vermeidet Wegoptimierung *)

  args.GetArg(0, argv[0]);   (* Programmname *)
  IF args.NumArgs() >= 1 THEN args.GetArg(1, argv[1]); END;

  IF args.NumArgs() < 1 THEN  (* Kein Dateiname angegeben *)
    io.WriteString(argv[0]); io.WriteString(" <Dateiname>\n");
    HALT(20);  (* Programm mit Fehlercode 20 beenden *)
  END;

  IF ReadText(argv[1]) = TRUE THEN
    io.WriteString("ReadText ok\n");

    w:= i.OpenWindowTagsA(NIL,
          i.waTitle    , s.ADR("PropGadget in Border Text 1.0"),
          i.waFlags    , LONGSET{i.windowDepth, i.windowDrag, i.windowClose,
                               i.windowSizing},
          i.waIDCMP    , LONGSET{i.closeWindow, i.idcmpUpdate, i.newSize},
          i.waMinWidth , MinWindowWidth,
          i.waMinHeight, MinWindowHeight,
          u.end);
  
    IF w # NIL THEN
      (*
         DrawInfo holen und APen für Textausgabe setzen. Da DrawInfo
         sonst nicht mehr gebraucht wird, wird der Speicher gleich
         wieder freigegeben(ist so übersichtlicher) der Zeiger in
         drInfo ist nach der Freigabe _nicht_ mehr gültig.
      *)

      drInfo:= i.GetScreenDrawInfo(w.wScreen);
      IF drInfo # NIL THEN
        g.SetAPen(w.rPort, drInfo.pens[i.textPen]);
        i.FreeScreenDrawInfo(w.wScreen, drInfo);
      END;

      (* Anzahl der sichtbaren Zeilen berechnen *)
      GetInnerWindow(w, iw);
      visibleLines:= iw.height DIV w.rPort.txHeight;

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
                i.pgaVisible,     visibleLines,
                i.pgaTotal,       numLines,
                i.pgaTop,         0,
                u.end);
  
      IF prop # NIL THEN
        dummy:= i.AddGList(w, prop, -1, -1, NIL); (* Gadget(s) dem Window hinzufügen *)
        i.RefreshGList(prop, w, NIL, -1);         (* Gadget(s) anzeigen              *)

        PrintPage(0);     (* Text ausgeben *)

        WHILE done = FALSE DO
  
          e.WaitPort(w.userPort);
          msg:= e.GetMsg(w.userPort);
  
          WHILE msg # NIL DO
  
            IF i.closeWindow IN msg.class THEN
              done:= TRUE;
            END;
  
            IF i.idcmpUpdate IN msg.class THEN
              (* Nachricht vom Prop-Gadget bearbeiten *)
              dummy:= i.GetAttr(i.pgaTop, prop, top);
              PrintPage(top);
            END;

            IF i.newSize IN msg.class THEN
              (*
                 Die Größe des Windows wurde verändert. Die neuen
                 Werte des inneren Windows müssen ermittelt,
                 visibleLines neu berechnet, das Prop-Gadget
                 angepaßt und der Text neu ausgegeben werden.
              *)
              GetInnerWindow(w, iw);
              visibleLines:= iw.height DIV w.rPort.txHeight;
              dummy:= i.SetGadgetAttrs(prop^, w, NIL, i.pgaVisible,
                                         visibleLines, u.end);
              dummy:= i.GetAttr(i.pgaTop, prop, top);
              PrintPage(top);
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

    FreeText();
  END;
END PropBorderTxt.
