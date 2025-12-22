/*
:Program.    agLeftText.rexx
:Contents.   Festgelegten Text linksbündig formatieren.
:Copyright.  (PD) 1999 Sven Drieling
:Version.    $VER: agLeftText.rexx 1.0 (27.6.99)
:Language.   ARexx
:History.    V1.0 indy 27-Jun-1999 first release

:Fehler

  Vordem ersten Wort wird ein Leerzeichen eingefügt. Die Korrektur
  ist in agLeftText_2.rexx zu finden.
*/

line = '"Was denken sie, warum hat sich dieser Mann mit einer Kaliber .98 Plastiksplittersprengmonsterkanone mit coolem Granatwerfertm erschossen?"'

out = ""

DO n = 1 TO WORDS(line)
  wort = WORD(line, n)

  IF LENGTH(out) + LENGTH(wort) < 50 THEN DO
    out = out wort
  END
  ELSE DO
    SAY out
    out = wort
  END
END

IF out ~= "" THEN SAY out
