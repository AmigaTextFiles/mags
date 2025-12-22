
/* Detta demoprogram deallokerar minne ifrån filen
 * Syntax:
 * Free Offset AntalBlock */

#include <dos/dos.h>
#include <stdlib.h>
#include <stdio.h>

#include <clib/dos_protos.h>
#include <pragmas/dos_pragmas.h>

#include "FileMem.h"

extern struct DosBase *DOSBase;

/* Detta är filnamnet på vmem filen */

STRPTR FilNamn="DemoFile.VMF";

void main(int argc, char **argv)
{
ULONG Block,Pos;
BPTR File;

	Pos=atol(argv[1]);
	Block=atol(argv[2]);

	if(!(File=Open(FilNamn, MODE_OLDFILE)))
	{
		printf("Kan inte öppna filen\n");
		exit(0);
	}

	FFreeMem(File, Pos, Block*12);

	Close(File);
}