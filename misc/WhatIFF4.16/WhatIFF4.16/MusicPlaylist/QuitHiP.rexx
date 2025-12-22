/*
  $VER: QuitHiP.rexx 1.0 (15.08.24)

  quits HippoPlayer if it's running
*/

IF SHOW("PORT", "HIPPOPLAYER") THEN DO
  ADDRESS HIPPOPLAYER
  QUIT
END
