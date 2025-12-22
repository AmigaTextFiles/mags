/*
:Program.    agSplitText.rexx
:Contents.   Festgelegten Text in einzelne Wörter zerlegen.
:Copyright.  (PD) 1999 Sven Drieling
:Version.    $VER: agSplitText.rexx 1.0 (27.6.99)
:Language.   ARexx
:History.    V1.0 indy 27-Jun-1999 first release
*/

line = '"Was denken sie, warum hat sich dieser Mann mit einer Kaliber .98 Plastiksplittersprengmonsterkanone mit coolem Granatwerfertm erschossen?"'

DO n = 1 TO WORDS(line)
  SAY WORD(line, n)
END

