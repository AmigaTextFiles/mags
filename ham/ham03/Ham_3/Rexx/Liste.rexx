/* ========== Liste.rexx ========== */
options prompt " Welches Laufwerk? > "
pull drive
say " Bitte warten..."

/* Header speichern */
befehl='list >ram:dummy' drive 'dirs quick nohead'
address COMMAND befehl

/* Inhalte speichern */
open(lese,"ram:dummy","r") /* Hilfs-Datei */
open(sende,"ram:Liste.txt","w")
call close(sende) /* In diese Datei schreibt LIST */
do while ~eof(lese) /* .info-Dateien überspringen */
 zeile=readln(lese)
 zeile='list >>ram:Liste.txt' drive||zeile 'p ~(#?.info)'
 address COMMAND zeile
  open(leer,"ram:Liste.txt","a")
   writeln(leer,"") /* Leerzeile */
  call close(leer)
end
call close(lese)

address COMMAND
'echo "*ec"'
'muchmore ram:Liste.txt' /* Ausgabe */
'delete >NIL: ram:dummy'
