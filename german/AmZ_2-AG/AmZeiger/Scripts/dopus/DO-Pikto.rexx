/************************************************/
/* DOpus5 Pikto+ Script V1.2.1                  */
/* (c)'97 by Andreas Schlick                    */
/* Arg: DO-Pikto.rexx ListerHandle              */
/************************************************/

IconToo = 0     /* Mit IconToo = 1 wird, wenn der Lister sich im          */
                /* Icon action Modus befindet, erst in den Icon Modus     */
                /* geschaltet und vom Icon Modus wird in den Name-Modus   */
                /* geschaltet                                             */

/* Ab hier nichts mehr aendern!!! */
options results; parse arg wlister; IF ~Show("P","DOPUS.1") THEN DO say "Error 1: Kann den DOpus ARexx-Port nicht finden."; EXIT; End;
address value DOPUS.1; 'lister query' wlister 'mode'; IF result="name" THEN 'lister set' wlister 'mode icon action'; else IF result="icon action" THEN DO; IF IconToo=1 THEN 'lister set' wlister 'mode icon'; else 'lister set' wlister 'mode name'; END; else if result="icon" THEN 'lister set' wlister 'mode name'; EXIT;

