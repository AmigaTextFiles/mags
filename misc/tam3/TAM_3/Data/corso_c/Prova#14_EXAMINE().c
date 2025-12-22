/*  Quattordicesimo programma: gestione files e informazioni relative  */

/*  1/1/95   */


#include <stdio.h>
#include <exec/memory.h>
#include <libraries/dosextens.h>

long rmask = ((long)('r') << 24);
long brmask = ((long)(' ') << 24);
long wmask = ((long)('w') << 16);
long bwmask = ((long)(' ') << 16);
long emask = ((long)('e') << 8);
long bemask = ((long)(' ') << 8);
long dmask = (long)('d');
long bdmask = (long)(' ');

struct
{
	long pmask;
	char stringnull;
} maskout;

struct FileInfoBlock *fib;
struct FileLock *lock;
struct FileLock *Lock();

int success, p;


main()
{
	fib = (struct FileInfoBlock *)AllocMem(sizeof(struct FileInfoBlock), MEMF_CLEAR);
	lock = Lock("hd0:c/dir", ACCESS_READ);
	if (lock)
	{
		success = Examine(lock, fib);
		if (success)
		{
			printf("\nFile name: %ls", fib->fib_FileName);
			if (fib->fib_DirEntryType > 0) printf("\nè una Directory");
			else printf("\nè un file");

			p = fib->fib_Protection;
			maskout.pmask = 0;
			maskout.stringnull = '\0';

			if (p & FIBF_READ) maskout.pmask |= brmask;
			else maskout.pmask |= rmask;

			if (p & FIBF_WRITE) maskout.pmask |= bwmask;
			else maskout.pmask |= wmask;

                        if (p & FIBF_EXECUTE) maskout.pmask |= bemask;
			else maskout.pmask |= emask;

			if (p & FIBF_DELETE) maskout.pmask |= bdmask;
			else maskout.pmask |= dmask;

			printf("\nHa i bit di protezione di valore %ls", &maskout);
			printf("\nHa una lunghezza di %ld Bytes", fib->fib_Size);
			printf("\n %ld in blocchi", fib->fib_NumBlocks);
			printf("\nCommento:\n %ls", fib->fib_Comment);
			printf("\nHa come data più recente:");
			/* ShowDate(&(fib->fib_Date));      */
		}

	}

	UnLock(lock);
}