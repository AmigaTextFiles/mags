/* ---Menüs- schließen - Mausknopf- */
/*' IDCMP = "MENUPICK+CLOSEWINDOW+MOUSEBUTTONS"  */
/* -- Mit  Schließgadget,ohne Rahmen  */
/*' Flags = "WINDOWCLOSE+BORDERLESS"               */
/*' CALL OPENWINDOW(Host, 0, 0, 0, 0,IDCMP, Flags, "Mein Arexx-Fenster")  */
/* Beispiel Zahlen addieren */
say "Zahl:"
pull a
say"Zahl addieren mit:"
pull b
c=a+b
say "Ergebnis: "c
