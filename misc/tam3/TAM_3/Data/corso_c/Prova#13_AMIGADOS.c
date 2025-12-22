/*  Tredicesimo programma: gestione di un comando AmigaDOS  */

/*  1/1/95   */


#include <stdio.h>
#include <libraries/dosextens.h>

int success;
struct FileHandle *Open(), *outhandle;

main()
{
	outhandle = Open("ram:dir.list", MODE_NEWFILE);
	if (outhandle == 0)
	{
		printf("\nI/O Error %ld\n", IoErr());
		exit(20);
	}

	success = Execute("dir", 0, outhandle);
	if (success == 0) printf("\nI/O Error %ld\n", IoErr());

	Close(outhandle);
}