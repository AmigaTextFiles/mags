/* MDSP - MicroDot Saves Puffer V1.71 */

/* Konfig-Teil */
/* ACHTUNG: Die Pfadangabe muß mit einem Slash oder Doppelpunkt enden!! */

Pfad_Transfer = "T:"
Pfad_Backup = "t:backup/"
Name_Backup = "Puffer"

/* Konfig-Teil ENDE */
SAY "   MicroDot Saves Puffer V1.71";SAY "  ----------------------------";SAY "  (c)`97 by A.Schlick";SAY "";SAY "Packe Puffer: ";SAY "";ADDRESS COMMAND "LHA a -D3 " || Pfad_Transfer || "caller.lha " || Pfad_Transfer || "PUFFER";Datep= word(date(),1) || "-" || substr(date("E"),4,2) || "-" || substr(date("E"),7,2);Dateq = left(time("N"),2) || "-" || substr(time("N"),4,2) || "-" || right(time("N"),2);SAY "Erstelle Backup des Puffers..";ADDRESS COMMAND "copy " || Pfad_Transfer || "caller.lha " || Pfad_Backup || Name_Backup || "." || Datep || "_" || Dateq;ADDRESS COMMAND "delete >>NIL: " || Pfad_Transfer || "PUFFER";EXIT;

