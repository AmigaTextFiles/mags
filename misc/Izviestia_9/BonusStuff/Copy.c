#include <stdlib.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <exec/memory.h>

int main(int argc, char *argv[])
{
   BPTR file;
   BPTR lock;
   APTR bufor;
   struct FileInfoBlock __aligned fib;

   if(argc!=3)
   {
      Printf("Za maîo argumentów!\n");
      exit(5);
   }

   if(!(lock=Lock(argv[1], ACCESS_READ)))
   {
      LONG a;
      a=IoErr();
      Printf("Byk = %d\n", a);

      Printf("Unable to lock \"%s\"\n", argv[1]);
      exit(10);
   }


   if(!Examine(lock, &fib))
   {
      LONG a;
      a=IoErr();
      Printf("Byk = %d\n", a);

      Printf("Unable to examine \"%s\"\n", argv[1]);
      UnLock(lock);
      exit(30);
   }

   if(!(bufor=AllocMem(fib.fib_Size, MEMF_CHIP)))
   {
      Printf("Unable to allocate memory!\n");
      UnLock(lock);
      exit(40);
   }

   if(!(file=Open(argv[1], MODE_OLDFILE)))
   {
      Printf("Unable to open file \"%s\"\n", argv[1]);
      FreeMem(bufor, fib.fib_Size);
      UnLock(lock);
      exit(50);
   }

   Read(file, bufor, fib.fib_Size);
   Close(file);
   UnLock(lock);

   if(!(file=Open(argv[2], MODE_NEWFILE)))
   {
      Printf("Unable to open file \"%s\"\n", argv[2]);
      FreeMem(bufor, fib.fib_Size);
      exit(60);
   }

   Write(file, bufor, fib.fib_Size);
   Close(file);

   FreeMem(bufor, fib.fib_Size);
   exit(0);
}
