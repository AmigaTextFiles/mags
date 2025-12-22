program omaikkuna;

uses exec, intuition;

var
  Ikkuna : PWindow;

begin
  if Not InitIntuitionLibrary then Halt(20);

  Ikkuna := OpenWindowTags(NIL, [WA_Left,0,WA_Top,0,
              WA_Width,200,
              WA_Height,200,
              WA_Title, DWord(PChar('Pascal ruulz')),
              WA_IDCMP,IDCMP_CLOSEWINDOW,
              WA_Flags,(WFLG_CLOSEGADGET or WFLG_DRAGBAR),
              TAG_DONE]);

  if Ikkuna=NIL then Halt(20);

  WaitPort(Ikkuna^.UserPort);
  GetMsg(Ikkuna^.UserPort);
  CloseWindow(Ikkuna);
end.
