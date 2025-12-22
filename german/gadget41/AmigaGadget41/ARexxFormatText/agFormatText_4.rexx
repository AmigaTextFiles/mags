/*
:Program.    agFormatText_4.rexx
:Contents.   Formatiert ASCII-Texte(Blocksatz, zentriert usw.)
:Copyright.  (PD) 1999 Sven Drieling
:Version.    $VER: agFormatText_4.rexx 1.0 (27.6.99)
:Language.   ARexx
:History.    V1.0 indy 27-Jun-1999 first release

:Aufruf

  agFormatText_4.rexx <format> <width> <fileName>

  format   - Gibt an wie der Text formatiert werden soll. Unterstützt
             werden folgende Formate:

               BLOCK  - Blocksatz
               CENTER - Zentriert
               LEFT   - Linksbündig
               RIGHT  - Rechtsbündig

  width    - Gewünschte Textbreite
  fileName - Dateiname des zu formatierenden ASCII-Textes.


:Ausgabe

  Formatierter ASCII-Text zur Standardausgabe.


:Fehler

  Aufgrund der Längenbeschränkung einer Zeichenkette auf 64KByte,
  bei ARexx, können nur Blöcke mit einer maximalen Länge von
  65535 Zeichen formatiert werden.
*/

PARSE ARG format width fileName

format   = STRIP(format)    /* Führende und nachfolgende Leerzeichen */
fileName = STRIP(fileName)  /* entfernen.                            */

IF ~OPEN(File, fileName, "R") THEN DO
  SAY "FEHLER!: Cant open" fileName
  EXIT 20
END

block = ""
DO WHILE ~EOF(File)

  line = READLN(File)

  IF line = "" THEN DO
    FormatBlock(format, block)
    SAY  /* Leerzeile zwischen Blöcken einfügen  */
    block = ""
  END
  ELSE DO

    IF block = "" THEN DO
        block = line
    END

    ELSE DO
      block = block line
    END

  END
END

/* Letzten Block ausgeben */
IF block ~= "" THEN FormatBlock(format, block)

EXIT 0
/*--------------------------------------------------------------*/

FormatBlock: PROCEDURE EXPOSE width  /* Direkter Zugriff auf width des */
                                     /* Hauptprogramms.                */
PARSE ARG format, line

out = WORD(line, 1)  /* out aufs erste Wort setzen */

DO n = 2 TO WORDS(line)  /* Schleife mit 2. Wort beginnen */
  wort = WORD(line, n)

  IF LENGTH(out) + LENGTH(wort) < width THEN DO
    out = out wort
  END
  ELSE DO
    SayLine(format, out)
    out = wort
  END
END

IF format = "BLOCK" THEN DO  /* Bei Blocksatz letzte Zeile linksbündig */
  SayLine("LEFT", out)       /* ausgeben.                              */
END
ELSE DO
  SayLine(format, out)
END

RETURN 0
/*--------------------------------------------------------------*/

SayLine: PROCEDURE EXPOSE width /* Direkter Zugriff auf width des */
                                /* Hauptprogramms.                */

PARSE ARG format, line

line = STRIP(line)          /* Führende und nachfolgende Leerzeichen */
                            /* entfernen.                            */

IF LENGTH(line) > width THEN DO
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
      numLeer = width - LENGTH(line)
      SAY COPIES(" ", numLeer) || line
    END

    WHEN format = "CENTER" THEN DO
      SAY CENTER(line, width)
    END

    WHEN format = "BLOCK" THEN DO

      IF WORDS(line) > 1 THEN DO

        block = WORD(line, 1)  /* block aufs erste Wort setzen */
  
        spaces  = width - LENGTH(line)
        numPlus = spaces %  (WORDS(line) - 1)
        numLeer = spaces // (WORDS(line) - 1)
        plus    = COPIES(" ", numPlus)
  
        DO n = 2 TO WORDS(line)  /* Schleife mit 2. Wort beginnen */
          wort = WORD(line, n)
  
          IF numLeer > 0 THEN DO
            block   = block || plus || " " wort
            numLeer = numLeer - 1
          END
          ELSE DO
            block   = block || plus wort
          END
        END
  
        SAY block
      END
      ELSE DO
        SAY line
      END
    END

    OTHERWISE DO
      SAY "FEHLER!: Unbekannte Formatierung: " format
      EXIT 10
    END
  END

END

RETURN 0

