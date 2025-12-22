#include <proto/exec.h>
#include <proto/dos.h>

#include <stdio.h>
#include <stdlib.h>

#include <libraries/xpk.h>

struct Library *XpkBase;

BPTR lock;
char errbuf[300];

void end(int kod);

void main(int argc, char *argv[])
{
   XFIB xfib;

   if(argc != 4)
   {
      printf("XPK file-packer. Usage:\n%s in_file out_file method\n", argv[0]);
      end(100);
   }

   if(!(XpkBase = OpenLibrary(XPKNAME, 0)))
   {
      printf("Cannot open "XPKNAME"\n");
      end(10);
   }

   if(!(lock = Lock(argv[1], ACCESS_READ)))
   {
      printf("Error %ld reading '%s'\n", IoErr(), argv[1]);
      end(20);
   }

   if(XpkExamineTags(&xfib, XPK_InName, argv[1], TAG_DONE))
   {
      printf("Error examining '%s'\n", argv[1]);
      end(40);
   }

   if(xfib.Type != XPKTYPE_UNPACKED)
   {
      printf("Skipping (already packed) '%s'\n", argv[1]);
      end(50);
   }

   /* pakowanie file-2-file */
   if(XpkPackTags(XPK_InName,     argv[1],
                  XPK_OutName,    argv[2],
                  XPK_FindMethod, argv[3],
                  XPK_GetError,   errbuf,
                  TAG_DONE))
   {
      printf("Pack error: '%s'\n", errbuf);
      end(60);
   }

   printf("File '%s' packed to file '%s'.\n", argv[1], argv[2]);
   end(0);
}

void end(int kod)
{
   if(lock)
      UnLock(lock);

   if(XpkBase)
      CloseLibrary(XpkBase);

   exit(kod);
}
