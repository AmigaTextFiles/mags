/* MST V1.3 beta 1                                      */
/* Miami Supports Tools                                 */
/* (c)`97 Andreas Schlick                               */
/* Dieses ARexx-Script ist FREEWARE!                    */

/* Installation:                                        */
/* Bei Miami-> Events -> Start oder End                 */
/* dieses Script eintragen (dann muss Miami = 0 sein!)  */
/*         Oder                                         */
/* Bei DOpus einen Knopf für ARexx definieren und       */
/* "Ausgabe in Fenster" aktivieren.                     */

/* Um die Tools zu starten muß als Parameter eine 0     */
/* übergeben werden und zum stopen eine 1               */

/* Bugs:                                                */
/* *MicroDot-II kann nicht beendet werden, da           */
/* wahrscheinlich ein ARexx-Port fehlt.                 */
/* *Es kann zu einer Fehlermeldung bei IBrowse kommen.  */
/* Diese Meldung dann bitte ignorieren.                 */

/* History:                                             */
/* V1.0: Erste Version; startete nur                    */
/*       die Tools                                      */
/* V1.1: Miami eingebunden                              */
/* V1.2: beendet jetzt auch die Tools                   */
/* V1.3: Die Dateinamen müssen specifiziert werden.     */
/*       Es wird jetzt gecheckt, ob die Tools auch      */
/*       beendet wurden.                                */

parse arg stst
options results

/* KONFIG:                                              */

Miami = 1
Miami_path = "Miami:Miami"

AmIRC = 0
AmIRC_path = "Internet:AmIRC/AmIRC"

AmTALK = 1
AmTALK_path = "Internet:AmTALK/AmTALK"

AmFTP = 0
AmFTP_path = "Internet:AmFTP/AmFTP"

YAM = 0
YAM_path = "YAM:YAM"

Voyager = 0
Voyager_path = "Internet:Voyager/V"

IBrowse = 0
IBrowse_path = "Internet:IBrowse/IBrowse"

MicroDot_II = 0
MicroDot_II_path = "Internet:MicroDot-II/MicroDot"

/* Aber hier nichts mehr aendern!!                      */
IF stst=0 THEN DO;IF ~SHOW('PORTS','MIAMI.1') & Miami=1 THEN ADDRESS COMMAND "run >NIL: " || Miami_path;IF ~SHOW('PORTS','AMIRC.1') & AmIRC = 1 THEN ADDRESS COMMAND "run >NIL: " || AmIRC_path;IF ~SHOW('PORTS','AMTALK') & AmTALK = 1 THEN ADDRESS COMMAND "run >NIL: " || AmTALK_path;IF ~SHOW('PORTS','AMFTP.1') & AmFTP = 1 THEN ADDRESS COMMAND "run >NIL: " || AmFTP_path;IF ~SHOW('PORTS','YAM') & YAM = 1 THEN ADDRESS COMMAND "run >NIL: " || YAM_path;IF ~SHOW('PORTS','VOYAGER') & Voyager = 1 THEN ADDRESS COMMAND "run >NIL: " || Voyager_path;
IF ~SHOW('PORTS','IBROWSE') & IBrowse = 1 THEN ADDRESS COMMAND "run >NIL: " || IBrowse_path;IF MicroDot_II = 1 THEN ADDRESS COMMAND "run >NIL: " || MicroDot_II_path;END;IF stst=1 THEN DO;IF SHOW('PORTS','AMIRC.1') & AmIRC = 1 THEN ADDRESS AMIRC.1 "QUIT";IF SHOW('PORTS','AMTALK') & AmTALK = 1 THEN ADDRESS AMTALK "QUIT";IF SHOW('PORTS','AMFTP.1') & AmFTP = 1 THEN ADDRESS AMFTP.1 "QUIT";IF SHOW('PORTS','YAM') & YAM = 1 THEN ADDRESS YAM "QUIT";IF SHOW('PORTS','VOYAGER') & Voyager = 1 THEN ADDRESS VOYAGER "QUIT";IF SHOW('PORTS','IBROWSE') & IBrowse = 1 THEN ADDRESS IBROWSE "QUIT";IF SHOW('PORTS','MIAMI.1') & MIAMI=1 THEN ADDRESS MIAMI.1 "QUIT";ADDRESS COMMAND wait 5;IF SHOW('PORTS','AMIRC.1') & AmIRC = 1 THEN ADDRESS AMIRC.1 "QUIT";IF SHOW('PORTS','AMTALK') & AmTALK = 1 THEN ADDRESS AMTALK "QUIT";IF SHOW('PORTS','AMFTP.1') & AmFTP = 1 THEN ADDRESS AMFTP.1 "QUIT";IF SHOW('PORTS','YAM') & YAM = 1 THEN ADDRESS YAM "QUIT";
IF SHOW('PORTS','VOYAGER') & Voyager = 1 THEN ADDRESS VOYAGER "QUIT";IF SHOW('PORTS','IBROWSE') & IBrowse = 1 THEN ADDRESS IBROWSE "QUIT";IF SHOW('PORTS','MIAMI.1') & MIAMI=1 THEN ADDRESS MIAMI.1 "QUIT";ADDRESS COMMAND wait 2;IF SHOW('PORTS','AMIRC.1') & AmIRC = 1 THEN SAY 'AmIRC konnte nicht beendet werden!';IF SHOW('PORTS','AMTALK') & AmTALK = 1 THEN SAY 'AmTALK konnte nicht beendet werden!';IF SHOW('PORTS','AMFTP.1') & AmFTP = 1 THEN SAY 'AmFTP konnte nicht beendet werden!';IF SHOW('PORTS','YAM') & YAM = 1 THEN SAY 'YAM konnte nicht beendet werden!';IF SHOW('PORTS','VOYAGER') & Voyager = 1 THEN SAY 'Voyager konnte nicht beendet werden!';IF SHOW('PORTS','IBROWSE') & IBrowse = 1 THEN SAY 'IBrowse konnte nicht beendet werden!';IF SHOW('PORTS','MIAMI.1') & MIAMI=1 THEN SAY 'Miami konnte nicht beendet werden!';ADDRESS COMMAND wait 5;END;
EXIT

