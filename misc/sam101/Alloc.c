
/* Detta demoprogram allokerar minne ifrån filen
 * Syntax:
 * Alloc AntalBlock */

#include <dos/dos.h>
#include <stdlib.h>
#include <stdio.h>

#include <clib/dos_protos.h>
#include <pragmas/dos_pragmas.h>

#include "FileMem.h"

extern struct DosBase *DOSBase;

/* Detta är filnamnet på vmem filen */

STRPTR FilNamn="DemoFile.VMF";

int main(int argc, char **argv)
{
ULONG Block,Pos;
BPTR File;

	if(1==argc)
	{
		printf("Syntax:\nAlloc Block\n");
		exit(0);
	}

	Block=atol(argv[1]);
	if(0==Block)
	{
		printf("Syntax:\nAlloc Block\n");
		exit(0);
	}

	if(!(File=Open(FilNamn, MODE_OLDFILE)))
	{
		printf("Skapar en ny fil\n");
		if(!(File=Open(FilNamn, MODE_NEWFILE)))
		{
			printf("Kan inte skapa filen\n");
			exit(NULL);
		}
		Pos=4;
		Write(File, &Pos, 4l);
		Pos=0;
		Write(File, &Pos, 4l);
		Write(File, &Pos, 4l);
		Pos=~11;
		Write(File, &Pos, 4l);
	}

	Pos=FAllocMem(File, Block*12);
	printf("\nAllokeringen lyckades vid pos:%d\n\n",Pos);
	Seek(File, Pos, OFFSET_BEGINING);

	for(;Block != NULL; Block--)
		Write(File, "Reserverad!!",12);

	Close(File);
}