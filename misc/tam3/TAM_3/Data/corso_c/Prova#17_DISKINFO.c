/*  17mo programma: Disk Info  */

/*  2/1/95   */


#include <stdio.h>
#include <exec/memory.h>
#include <libraries/dosextens.h>

main()
{
	struct InfoData *id;
	int success, p;
	struct Lock *lock;

	struct
	{
		long pmask;
		char stringnull;
	} maskout;

	maskout.stringnull = '\0';
	id = (struct InfoData *)AllocMem(sizeof(struct InfoData), MEMF_CLEAR);
	lock = Lock("hd0:c/dir", ACCESS_READ);

	if (lock)
	{
		success = Info(lock, id);
		if (success)
		{
			if (id->id_DiskType == -1)
			{
				printf("\nNON CI SONO DISCHI\n");
			}
			else
			{
				printf("\nErrori Soft sino a qui %ld", id->id_NumSoftErrors);
				printf("\n# dell' unità dove è montato: %ld", id->id_UnitNumber);
				printf("\nStato del disco: ");
				if (id->id_DiskState == ID_WRITE_PROTECTED) printf("Write Protected");
				else if (id->id_DiskState == ID_VALIDATED) printf("Read/Write");
				else if (id->id_DiskState == ID_VALIDATING) printf("Validating Disk");
				printf("\nIl disco ha %ld blocchi", id->id_NumBlocks);
				printf("\n   di cui %ld sono utilizzati", id->id_NumBlocksUsed);
				printf("\nVi sono %ld bytes per ogni blocco", id->id_BytesPerBlock);
				printf("\nTipo di disco: ");
				maskout.pmask = id->id_DiskType;
				printf(&maskout);
				if(id->id_InUse == 0) printf("\nIl disco è utilizzato");
				else printf("\nIl disco non è utilizzato");
			}
		}
	}

	UnLock(lock);
}
