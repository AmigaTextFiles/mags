(***************************************************************************

    MODUL
      jgrep.mod

    DESCRIPTION
      sucht in Textdateien nach einem Muster und gibt alle Zeilen aus, in
      denen es enthalten ist.
      optionale Flags:
         SLOW: Anstelle des Boyer-Moore Algorithmus' wird die direkte Suche
               benutzt - interessant sicherlich nur mit dem DEBUG-Flag.
         DEBUG: Es werden einige zusätzliche Informationen, wie die Anzahl
                der durchgeführten Vergleiche ausgegeben.

    NOTES
      Der Boyer-Moore Algorithmus ist optimierbar, indem das skip-Array
      nicht für jede Zeile neu berechnet wird, sondern einmal am Anfang.
      Ich habe es hier nur einmal so realisiert, um den Algorithmus
      geschlossen in sich zu halten.

    BUGS

    TODO

    EXAMPLES

    SEE ALSO

    INDEX

    HISTORY
      11-11-95 Roland (rj,-) Jesse  created

***************************************************************************)

<*STANDARD-*>               (* necessary for assignable cleanup procedure *)

MODULE jgrep;

IMPORT
   jgrepRev,
   Errors, Kernel,
   d := Dos,
   e := Exec,
   f := Files,
   Out,
   S := SYSTEM,
   Strings;

TYPE
   String = ARRAY 256 OF CHAR;
   IntArray = ARRAY 256 OF INTEGER;

CONST
   template = "PATTERN/A,FILE/A,S=SLOW/K/S,D=DEBUG/K/S";
   optPattern = 0;
   optFile = 1;
   optSlow = 2;
   optDebug = 3;
   optCount = 4;                 (* Anzahl der Parameter *)

   CR = 0DX; LF = 0AX;

VAR
   rdArgs : d.RDArgsPtr;
   file  : e.LSTRPTR;
   pattern : e.LSTRPTR;
   line : String;
   succ : BOOLEAN;               (* search successful ? *)
   debug : BOOLEAN;              (* debug-mode ? *)
   slow : BOOLEAN;               (* direkte Suche verwenden ? *)
   fhandle : f.File;             (* File-Handle für die Datei *)
   r : f.Rider;
   ch : CHAR;
   compares, i : INTEGER;


(* Remove all the allocated stuff *)
PROCEDURE* Cleanup (VAR rc : LONGINT);
BEGIN
   IF fhandle # NIL THEN f.Close (fhandle) END;
   IF rdArgs # NIL THEN d.FreeArgs (rdArgs) END
END Cleanup;


PROCEDURE Init;
BEGIN
   (* Errors.Init; *)
   Kernel.SetCleanup (Cleanup);
   rdArgs := NIL; slow := FALSE; debug := FALSE; compares := 0;
   COPY ("", line)
END Init;


PROCEDURE GetArgs;
VAR
   argArray : ARRAY optCount OF S.LONGWORD;
BEGIN
   rdArgs := d.OldReadArgs (template, argArray, NIL);
   IF rdArgs # NIL THEN
      (*
       * Wegen dem /A steht in beiden auf jeden Fall etwas.
       *)
      pattern := S.VAL (e.LSTRPTR, argArray [optPattern]);
      file := S.VAL (e.LSTRPTR, argArray [optFile]);
      slow := S.VAL (BOOLEAN, argArray [optSlow]);
      debug := S.VAL (BOOLEAN, argArray [optDebug]);
   ELSE
      ASSERT (d.PrintFault (d.IoErr(), "ReadArgs"));
      HALT (d.error)
   END
END GetArgs;


(* direkte Suche, optimierte Version (Abbruch bei erstem Mismatch) *)
PROCEDURE SlowSearch () : BOOLEAN;
VAR
   i, j, M, N : INTEGER;
   m, z : String;

BEGIN (* SlowSearch *)
   COPY (line, z);
   COPY (pattern^, m);
   M := Strings.Length (m); N := Strings.Length (z);

   (* neue Fassung: *)
   i := 0; j := 0;
   REPEAT
      IF z[i] = m[j] THEN
         INC (i); INC (j); INC (compares);
      ELSE
         i := i - j + 1;
         j := 0;
         INC (compares);
      END;
   UNTIL (j = M) OR (i >= N);

   IF j = M THEN
      RETURN TRUE
   ELSE
      RETURN FALSE
   END
END SlowSearch;


(* f. BMsearch *)
PROCEDURE initskip ( VAR skip : IntArray );
VAR
 j, t, M : INTEGER;
 m : String;

BEGIN
   COPY (pattern^, m);
   M := Strings.Length (m);
   FOR j := 0 TO 255 DO
      skip[j] := M
   END;

   FOR j := 0 TO M-1 DO
      t := ORD (m[j]);
      skip[t] := M-j-1
   END
END initskip;


PROCEDURE BMsearch () : BOOLEAN;
VAR
   i, j, t, M, N : INTEGER;
   skip : IntArray;
   m, z : String;

BEGIN
   COPY (line, z);
   COPY (pattern^, m);
   M := Strings.Length (m); N := Strings.Length (z);

   initskip (skip);

   i := M-1; j := M-1;
   REPEAT
      IF z[i] = m[j] THEN
         INC (compares);
         DEC (i);
         DEC (j);
      ELSE (* Mismatch wegen z[i] => i erhöhen, j ans Ende des Musters *)
         INC (compares);
         t := skip[ ORD (z[i]) ];
         IF M-j > t THEN
            i := i + M-j
         ELSE
            i := i + t
         END;
         j := M-1
      END
   UNTIL (j < 0) OR (i >= N);

   IF i >= N THEN
      RETURN FALSE
   ELSE
      RETURN TRUE
   END
END BMsearch;


PROCEDURE ClearLine;
VAR
   i : INTEGER;
BEGIN (* ClearLine *)
   FOR i := 0 TO 255 DO
      line[i] := ""
   END
END ClearLine;


<*$CopyArrays-*>
BEGIN (* grep *)
   Init ();
   GetArgs ();

   (* open file *)
   fhandle := f.Old (file^);
   IF fhandle # NIL THEN
      f.Set (r, fhandle, 0);

      WHILE ~r.eof DO
         f.Read (r, ch);
         LOOP
            ClearLine;
            (* read in next line *)
            i := 0;
            line[i] := ch;
            WHILE ch # LF DO
               INC (i);
               f.Read (r, ch);
               line[i] := ch;
            END;

            (* search for the pattern *)
            IF slow = TRUE THEN
               succ := SlowSearch ()
            ELSE
               succ := BMsearch ()
            END;

            (* print the line when found the pattern *)
            IF succ = TRUE THEN
               IF debug = TRUE THEN
                  IF slow = TRUE THEN Out.String ("dS: ");
                                 ELSE Out.String ("BM: ");
                  END;
               END;
               Out.String (line)
            END;
         f.Read (r, ch);
         IF r.eof THEN EXIT END
         END; (* of LOOP *)
      END; (* WHILE ~r.eof *)

      IF debug = TRUE THEN
         IF slow = TRUE THEN Out.String ("dS, ")
                        ELSE Out.String ("BM, ")
         END;
         Out.String ("Anz. Vergleiche: "); Out.Int (compares, 3); Out.Ln ()
      END;
      f.Close (fhandle); fhandle := NIL;
   ELSE
      Out.String ("Could not open "); Out.String (file^); Out.Ln ()
   END;
   IF debug = TRUE THEN Out.String ("done\n") END
END jgrep.

