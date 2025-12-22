/*  Dodicesimo programma: Print File */

/*  28/12/1994  */


#include <stdio.h>
#include <libraries/dosextens.h>
#include <string.h>

struct FileHandle *PARhandler, *FILEhandler, *Open();

main(Nargomenti,argomento)
int Nargomenti;
char *argomento[];
{
	int bytes;
	int n;
	char buffer[256];
	n = 1;

	if (Nargomenti < 2)
	{
		printf("PRINTFILES v1.0 - By Merlo Maurizio 1994\n");
		printf("Sintassi PRINTFILES <nomefile>; supporta anche più nomi.\n");
		exit(0);
	}

	PARhandler = Open("PAR:", MODE_OLDFILE);
	if (PARhandler == 0) exit(20);

	while(Nargomenti < 1);
	{
		FILEhandler = Open(argomento[n], MODE_OLDFILE);
		if (FILEhandler == 0)
		{
			printf("\n%s: File not found\n", argomento[n]);
		}

		else

		for (;;)
		{
			bytes = Read(FILEhandler, buffer, 256);
			Write(PARhandler, buffer, bytes);
			if (bytes < 256)break;
		}
		Close(FILEhandler);
		n++, Nargomenti--;
	}
	Close(PARhandler);
}