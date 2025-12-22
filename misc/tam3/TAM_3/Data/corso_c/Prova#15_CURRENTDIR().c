/*  Quindicesimo programma: gestione directory  */

/*  2/1/95   */


#include <stdio.h>
#include <libraries/dosextens.h>
#include <exec/memory.h>

struct FileLock *Lock(), *DupLock(), *CurrentDir(), *oldlock;

main()
{
	oldlock = Lock("",ACCESS_READ);
	if (oldlock != 0)
	{
		followthread(oldlock, 0);
	}
	else
	{
		printf("\nNon posso bloccare la directory corrente\n");
	}

	printf("\n");
}

int followthread(lock, tab_level)
struct FileLock *lock;
int tab_level;
{
	struct FileLock *newlock, *oldlock, *ignoredlock;
	struct FileInfoBlock *fib;
	int success, i;

	if (!lock) return(0);

	fib = (struct FileInfoBlock *)AllocMem(sizeof(struct FileInfoBlock), MEMF_CLEAR);
	success = Examine(lock, fib);
	while (success != 0)
	{
		if (fib->fib_DirEntryType > 0)
		{
			newlock = Lock(fib->fib_FileName[0], ACCESS_READ);
			oldlock = CurrentDir(newlock);

			followthread(newlock, tab_level+1);

			ignoredlock = CurrentDir(oldlock);
		}

		success = ExNext(lock, fib);
		if (success)
		{
			printf("\n");
			for (i=0; i<tab_level; i++) printf("\t %ls", fib->fib_FileName[0]);

			if (fib->fib_DirEntryType > 0) printf(" [ dir ]");
                }
	}

	if (lock) UnLock(lock);
	FreeMem(fib, sizeof(struct FileInfoBlock));
}
