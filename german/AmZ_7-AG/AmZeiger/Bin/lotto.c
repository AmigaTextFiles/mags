/* Lotto: Ausgabe von 6 Zufallszahlen aus 49
   (Entscheidungshilfe für unentschlossene Tipper :)

   ANSI-C - Sollte mit jedem C-Compiler auf jeder Plattform
   funktionieren */


/* Benötigte Include-Dateien */
#include <stdlib.h>
/* für abs(), rand(), srand() und qsort() */

#include <stdio.h>
/* für vprintf() */

#include <time.h>
/* für time() */


/* Prototypen für eigene Funktionen */
int sortfunc(const void *a, const void *b);


/* Die Behälter für die sechs Kugeln... */
int zahl[6] = {0, 0, 0, 0, 0, 0};


/* Die Hauptfunktion. Es werden keine Parameter benötigt,
   und es wird nichts zurückgegeben. Wenn der Compiler sich
   beschwert, kann man unbesorgt auch

   int main(int argc, char **argv)

   schreiben. */

void main(void)
{
   int i, j;   /* Zwei Schleifenzähler */

   srand(time(0));   /* Zufallsgenerator mit Zufallswert starten */

   /* Wir brauchen sechs Zahlen */
   for(i = 0; i < 6; i++)  /* ZUFALLSZAHLEN-SCHLEIFE */
   {
      /* Zahl aus 1 bis 49 besorgen:
         Vom Zufallswert "rand()" wird per Modulo-Operator der Rest
         der Division durch 49 erzeugt. Vorher sicherstellen, daß die
         Zahl auch positiv ist (mit abs()). Der Rest kann die Werte
         0 bis 48 annehmen. Also noch eins dazurechnen und fertig ! */

      zahl[i] = (abs(rand()) % 49) + 1;

      /* Erst mal sehen, ob die Zahl schon mal erzeugt wurde. Dazu
         müssen alle durchgesehen werden. Die Initialisierung mit
         dem (für Lottozahlen ungültigen) Wert null bei der Deklaration
         sorgt schon mal für etwas Kontrolle. */

      for(j = 0; j < 6; j++)  /* VERGLEICHS-SCHLEIFE */
      {
         /* Diese Bedingung greift nur solange, wie schon Zahlen
            erzeugt wurden. Wurden z.B. erst zwei erzeugt, braucht
            man natürlich nicht nachsehen, ob die anderen vier
            eventuell auch doppelt sind. Das spart einiges an Zeit. */

         if(i != j)
         {
            /* Hier werden jetzt die Zahlen verglichen. Ist es eine,
               die schon mal vorkam, wird sie in der Zufallszahlen-
               schleife neu berechnet (i--;) und die Vergleichs-
               schleife abgebrochen (j = 6;). */

            if(zahl[i] == zahl[j])
            {
               i--;
               j = 6;
            }
         }

         /* Optional könnte man auch auf (j < i) abfragen und dann
            die Vergleichs-Schleife hier mittels (else j = 6;) oder
            (else break;) abbrechen. Das wäre noch schneller, erzeugt
            aber auch mehr Code. Und verstehen sollte man es nach ein
            paar Jahren auch noch können. */
      }
   }

   /* Jetzt noch die Zahlen aufsteigend sortieren. Dazu muß man der
      qsort()-Funktion das Array ("zahl"), die Anzahl der Einträge
      im Array ("6"), die Größe der zu verarbeitenden Elemente
      ("sizeof(int)") und letztlich die Verarbeitungsvorschrift in
      Form einer Funktion ("&sortfunc") übergeben. */

   qsort(zahl, 6, sizeof(int), &sortfunc);

   /* Und zum Schluß trickreich ausgeben */

   vprintf("Lottozahlenvorschlag (6 aus 49): %d, %d, %d, %d, %d, %d\n",
      (va_list) zahl);
}


/* Die qsort()-Funktion erwartet von der Vergleichsvorschrift, daß sie
   den Wert -1 zurückgibt, wenn das erste Argument kleiner als das
   zweite ist; den Wert 0, falls beide Argumente gleich sind; und den
   Wert 1, wenn das erste Argument größer ist.
   Das ist aber nicht zwingend: Vertauscht man 1 und -1, sortiert man
   eben absteigend, statt aufsteigend. */

int sortfunc(const void *a, const void *b)
{
   /* Der folgende Typecast ist nötig, wenn man ANSI-konform bleiben
      will. Um qsort() nicht beim Datentyp einzuschränken, sind die
      Argumente als typenlose Zeiger (void *) deklariert. Wir wollen
      aber Integers für unsere Zahlen, also definiert man eben zwei
      Integer-Zeiger und konvertiert den Datentyp ausdrücklich nach
      (int *). */

   int *aa, *bb;

   aa = (int *) a;
   bb = (int *) b;

   /* ACHTUNG: Die Argumente sind nicht die Zahlen aus unserem Array,
      sondern nur ZEIGER auf die Zahlen IM Array. Man muß hier also
      dereferenzieren, entweder mit (*aa), wie hier geschehen, oder
      mit (aa[0]), was auch möglich ist. */

   if(*aa < *bb)
   {
      return(-1);
   }
   else if(*aa > *bb)
   {
      return(1);
   }

   return(0);
}
