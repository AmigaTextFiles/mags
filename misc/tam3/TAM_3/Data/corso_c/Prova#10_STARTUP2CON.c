/*  Decimo programma: Legge la Startup-Sequence e stampa in CON: */

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
        accessmode = MODE_OLDFILE;
        filehandle = Open(pathname, accessmode);
        conteggio = Read(filehandle, &leggere, 2000);
	Close(filehandle);

        pathname = "CON:10/10/500/250/S:Startup-Sequence";
        accessmode = MODE_NEWFILE;
	filehandle = Open(pathname, accessmode);
        conteggio = Write(filehandle, &leggere, 2000);
	Close(filehandle);
}
