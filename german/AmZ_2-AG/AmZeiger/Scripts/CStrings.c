#include <string.h>
#include <stdio.h>

/* Die Dateien enthalten sog. Prototypen, also Erklärungen für den
Compiler, wie Funktionen wie strcpy aufgerufen werden müssen. Damit
er prüfen kann, ob wir alles richtig programmiert haben. Bei C gibt
es nämlich (im Gegensatz zu vielen anderen Sprachen) keine einge-
bauten Befehle, wie PRINT in Basic. Durch das include weiß der
Compiler, daß es eine Funktion wie printf() überhaupt gibt. Und
verwendet sie. Der Linker stellt dann nach dem Compilieren fest,
daß man gar kein printf() definiert hat, und sucht es deshalb in
den Linker-Bibilotheken, wo er im Fall von printf() auch fündig wird. */

char zeilen[20][70];     /* maximal 20 Zeilen a 80 Zeichen. */
int zeilenanz;

void eingabe()
{
     short cnt;

        for( cnt = 0; cnt < 20; cnt++)
        {
                gets( zeilen[cnt] );
                if( zeilen[cnt][0] == 0 )
                        break;

                /*
                 * Mit break wird hier ausgestiegen, wenn eine Leerzeile
                 * eingegeben wurde. Man bemerke  die Abfrage des 0-Bytes,
                 * welches am Stringanfang eines leeren Strings steht.
                 */
        }
        zeilenanz = cnt;
}

void ausgabe()
{
        short cnt, laenge, leeranz, leercnt;
        char ausgabestr[80];
        for( cnt = 0; cnt < zeilenanz; cnt++ ) {
                /* Länge der Zeichenkette feststellen: */
                laenge = strlen( zeilen[cnt] );
                /* Wir müssen nun die Hälfte der Differenz der Anzahl
                der Zeichen des Strings und 70 feststellen! */
                leeranz = (70-laenge) / 2;
                /* diese Anzahl von Leerzeichen müssen ausgegeben
                werden, damit der Text zentriert erscheint. Wir
                basteln jetzt einen String, der leeranz Leerzeichen
                und die jeweils eingegebene Zeile enthält.*/

                for( leercnt = 0; leercnt < leeranz; leercnt++ ) {
                        ausgabestr[leercnt] = ' ';
                }
                ausgabestr[leercnt] = 0;

                strcat( ausgabestr, zeilen[cnt] );
                /* strcat fügt den String in zeile[cnt] an ausgabestr an,
                nur zu verwenden bei Strings, in denen man schon ein 0-Byte
                gesetzt hat.*/

                printf("%s\n", ausgabestr );
        }
}


void main( )
{
        printf("Sie können jetzt maximal 20 Zeilen a 70 Zeichen angeben, wenn Ihnen schon\n"
                "vorher die Ideen ausgehen, drücken Sie einfach <Return> in einer leeren\n"
                "Zeile.\n");
        eingabe();
        ausgabe();
        printf("Das wars!\n");
        // welch ein Musterprogramm!

        /* Was hatte eigentlich das \n oben zu sagen? Nun, <I>printf()</I> und Konsorten
        können noch diverse Steuersequenzen auswerten. Dazu zählt \n. \n sorgt
        für einen Zeilenumbruch im Shellfenster. */

}


