/*
:Program.    agRightText.rexx
:Contents.   Festgelegten Text rechtsbündig formatieren.
:Copyright.  (PD) 1999 Sven Drieling
:Version.    $VER: agRightText.rexx 1.0 (27.6.99)
:Language.   ARexx
:History.    V1.0 indy 27-Jun-1999 first release
*/

line = '"Was denken sie, warum hat sich dieser Mann mit einer Kaliber .98 Plastiksplittersprengmonsterkanone mit coolem Granatwerfertm erschossen?"'

out = ""

out = WORD(line, 1)  /* out aufs erste Wort setzen */
    
DO n = 2 TO WORDS(line)  /* Schleife mit 2. Wort beginnen */
  wort = WORD(line, n)

  IF LENGTH(out) + LENGTH(wort) < 50 THEN DO
    out = out wort
  END
  ELSE DO
    numLeer = 50 - LENGTH(out)
    SAY COPIES(" ", numLeer) || out
    out = wort
  END
END

numLeer = 50 - LENGTH(out)
IF out ~= "" THEN SAY COPIES(" ", numLeer) || out

