/*  Nono programma: Leggi la Startup-Sequence  */

/*  27/12/1994  */


#include <stdio.h>
#include <libraries/dosextens.h>
#include <string.h>

struct FileHandle *filehandle, *Open();
char *pathname;
int accessmode;
char leggere[2000];
int conteggio;

main()
{
	pathname = "HD0:S/Startup-Sequence";
	conteggio = 0;
	accessmode = MODE_OLDFILE;
        filehandle = Open(pathname, accessmode);
        conteggio = Read(filehandle, &leggere, 2000);
	Close(filehandle);

	printf("\nHo letto:\n\n%s\n\n di %d caratteri", leggere, conteggio);
}
