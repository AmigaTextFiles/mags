/*
:Program.    agFormatText_1.rexx
:Contents.   Festgelegten Text formatieren(links-/rechtsbündig, zentriert)
:Copyright.  (PD) 1999 Sven Drieling
:Version.    $VER: agFormatText_1.rexx 1.0 (27.6.99)
:Language.   ARexx
:History.    V1.0 indy 27-Jun-1999 first release

:Aufruf

  agFormatText_1.rexx <format>

  format   - Gibt an wie der Text formatiert werden soll. Unterstützt
             werden folgende Formate:

               CENTER - Zentriert
               LEFT   - Linksbündig
               RIGHT  - Rechtsbündig

             Die Zeilenlänge ist fest auf 50 Zeichen/Zeile eingestellt.
  
:Ausgabe

  Formatierter ASCII-Text zur Standardausgabe oder bei auftreten
  eines Fehlers ein Fehlercode ab 10.
*/

PARSE ARG format

format   = STRIP(format)    /* Führende und nachfolgende Leerzeichen */
                            /* entfernen.                            */

line = '"Was denken sie, warum hat sich dieser Mann mit einer Kaliber .98 Plastiksplittersprengmonsterkanone mit coolem Granatwerfertm erschossen?"'

out = WORD(line, 1)  /* out aufs erste Wort setzen */

DO n = 2 TO WORDS(line)  /* Schleife mit 2. Wort beginnen */
  wort = WORD(line, n)

  IF LENGTH(out) + LENGTH(wort) < 50 THEN DO
    out = out wort
  END
  ELSE DO
    SayLine(format, out)
    out = wort
  END
END

IF out ~= "" THEN SayLine(format, out)

EXIT 0

/*--------------------------------------------------------------*/

SayLine: PROCEDURE

PARSE ARG format, line

line = STRIP(line)          /* Führende und nachfolgende Leerzeichen */
                            /* entfernen.                            */

IF LENGTH(line) > 50 THEN DO
  SAY "FEHLER!: Die erzeugte Zeile ist länger als 50 Zeichen. "
  SAY "Sie könnten die Breite des Textes erhöhen oder "
  SAY "das überlange Wort kürzen bzw. "
  SAY "durch Trennungen aufteilen: " out
  EXIT(10)
END
ELSE DO

  SELECT
    WHEN format = "LEFT" THEN DO
      SAY line
    END

    WHEN format = "RIGHT" THEN DO
      numLeer = 50 - LENGTH(line)
      SAY COPIES(" ", numLeer) || line
    END

    WHEN format = "CENTER" THEN DO
      SAY CENTER(line, 50)
    END

    OTHERWISE DO
      SAY "FEHLER!: Unbekannte Formatierung: " format
      EXIT(10)
    END
  END

END

RETURN 0

