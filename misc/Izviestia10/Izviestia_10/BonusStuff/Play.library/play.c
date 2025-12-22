#include <stdio.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <exec/memory.h>
#include <pragmas/play_pragmas.h>

struct Library *PlayBase=NULL;

/*
   poniûsze definicje sâ potrzebne,
   ale moûna je "przerzuciê" do np. "include:clib/play.h",
   a podczas kompilacji include'owaê (?) ten plik
*/
extern void InitPlay(LONG *module);
extern void ClosePlay(LONG *module);

/* program gîówny */
int main(int argc, char *argv[])
{
   BPTR file;
   BPTR lock;
   LONG *bufor;
   struct FileInfoBlock __aligned fib;

	if(PlayBase=OpenLibrary("play.library", 0))
	{
      if(!(lock=Lock(argv[1], ACCESS_READ)))
      {
         printf("Unable to lock module: error %d\n", IoErr());
         return 10;
      }

      if(!Examine(lock, &fib))
      {
         printf("Unable to examine module: error %d\n", IoErr());
         UnLock(lock);
         return 30;
      }

      if(!(bufor=AllocMem(fib.fib_Size, MEMF_CHIP)))
      {
         printf("Unable to allocate memory!\n");
         UnLock(lock);
         return 40;
      }

      if(!(file=Open(argv[1], MODE_OLDFILE)))
      {
         printf("Unable to open module: error %d\n", IoErr());
         FreeMem(bufor, fib.fib_Size);
         UnLock(lock);
         return 50;
      }

      Read(file, bufor, fib.fib_Size);
      Close(file);
      UnLock(lock);

   	InitPlay(bufor);     /* zapuszczamy mjuzyêku */

      while (getchar()!='q')
   	{
         /* program blokuje cli i czeka na wciôniëcie 'q' i entera*/
      }

   	ClosePlay(bufor); /* wykluciajem mjuziczku*/
      FreeMem(bufor, fib.fib_Size); /* i oddajemy coômy zabrali*/
   }
   return 0;
}
