/*  Ottavo programma: Files  */

/*  27/12/1994  */


#include <stdio.h>
#include <libraries/dosextens.h>
#include <string.h>

struct FileHandle *filehandle, *Open();
char *pathname;
int accessmode;
char scrivere[20];
char leggere[20];
int conteggio;

main()
{
	pathname = "ram:file.prova";
	accessmode = MODE_NEWFILE;
	filehandle = Open(pathname, accessmode);
        strcpy(scrivere, "Ho scritto questo !!");
        conteggio = Write(filehandle, &scrivere, 20);
	printf("\nHo scritto %s di %d caratteri", scrivere, conteggio);
        Close(filehandle);

	conteggio = 0;
	accessmode = MODE_OLDFILE;
        filehandle = Open(pathname, accessmode);
        conteggio = Read(filehandle, &leggere, 20);
	Close(filehandle);

	printf("\nHo letto:  %s di %d caratteri", leggere, conteggio);
}
