/*  Undicesimo programma: Legge la Startup-Sequence e stampa in CON: */

/*  28/12/1994  */


#include <stdio.h>
#include <libraries/dosextens.h>
#include <string.h>

struct FileHandle *filehandle, *Open();
char *pathname;
int accessmode;
char leggere[2000];
int conteggio;
int lunghezza;

main()
{
	printf("\n  Scrivi qualcosa nella finestra che si aprirà;");
	printf("\n  verrà scritto in RAM: in un file. Ciao!\n");
	printf("..premi RETURN per cominciare");
	gets(pathname);

	pathname = "CON:10/10/500/250/Scrivi qualcosa...";
        accessmode = MODE_NEWFILE;
        filehandle = Open(pathname, accessmode);
        conteggio = Read(filehandle, &leggere, 2000);
	Close(filehandle);

	leggere[conteggio] = '\0';
        lunghezza = conteggio;

	printf("\n\nHai scritto %d caratteri.\n", lunghezza);

	pathname = "RAM:ScrittoDaTe.ASCII";
	accessmode = MODE_NEWFILE;
	filehandle = Open(pathname, accessmode);
	conteggio = Write(filehandle, &leggere, lunghezza);
	Close(filehandle);
}
