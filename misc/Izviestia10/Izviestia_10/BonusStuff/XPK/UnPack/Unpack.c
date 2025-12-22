#include <proto/exec.h>
#include <proto/dos.h>

#include <stdio.h>
#include <stdlib.h>

#include <libraries/xpk.h>

struct Library *XpkBase;   /* baza bilioteki */

BPTR lock;           /* blokada pliku */
char errbuf[300];    /* miejsce na komunikaty o bîëdach */

void end(int kod);   /* funkcja wychodzâca, stworzona póúniej */

/* program gîówny */
void main(int argc, char *argv[])
{
   XFIB xfib;

   /* czy sâ 2 argumenty? */
   if(argc!=3)
   {
      printf("XPK file-unpacker. Usage:\n%s in_file out_file\n", argv[0]);
      end(100);
   }

   /* otwieramy bibliotekë */
   if(!(XpkBase = OpenLibrary(XPKNAME, 0)))
   {
      printf("Cannot open "XPKNAME"\n");
      end(10);
   }

   /* blokujemy dostëp do pliku */
   if(!(lock = Lock(argv[1], ACCESS_READ)))
   {
      printf("Error %ld reading '%s'\n", IoErr(), argv[1]);
      end(20);
   }

   /* odczytujemy dane o pliku - struktura XFIB */
   if(XpkExamineTags(&xfib, XPK_InName, argv[1], TAG_DONE))
   {
      printf("Error examining '%s'\n", argv[1]);
      end(40);
   }

   /* czy plik jest spakowany? */
   if(xfib.Type != XPKTYPE_PACKED)
   {
      printf("Skipping (already unpacked) '%s'\n", argv[1]);
      end(50);
   }

   /* rozpakowywujemy sposobym file-2-file */
   if(XpkUnpackTags(XPK_InName,   argv[1],
                  XPK_OutName,    argv[2],
                  XPK_GetError,   errbuf,
                  TAG_DONE))
   {
      printf("Pack error: '%s'\n", errbuf);
      end(60);
   }

   printf("File '%s' unpacked to file '%s'.\n", argv[1], argv[2]);
   end(0);
}

/* funkcja wychodzâca */
void end(int kod)
{
   /* zwalniamy plik */
   if(lock)
      UnLock(lock);

   /* zamykamy bibliotekë */
   if(XpkBase)
      CloseLibrary(XpkBase);

   /* wychodzimy z podanym kodem (dostëpny np. poprzez SET z ADosu - RC) */
   exit(kod);
}
