/* ======================================================== *
 * IZIO    ___    3DIZIO.c                                  *
 * SOFT   / //    Estrae da un file oggetto TDDD tre files  *
 * ___   / //     contenenti punti, spigoli e facce in      *
 * \ \\ / //      formato RAW                               *
 *  \ \/ //                                                 *
 *   \__//                        (c)1996 Maurizio DEEP RED *
 *                           SAS/C v6.51 Development System *
 * -------------------------------------------------------- *
 * DATA: Sab 10-Feb-1996              VER ... 0.5           *
 * S.O. / HW .....                    REV ... beta          *
 * NOTE: Speriamo che funzioni...                           *
 * ======================================================== */


/* ------  FILES DI INCLUDE  ------ */
#include <stdio.h>
#include <stdlib.h>

/*  -----  FILES DI INCLUDE  -----  */
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <dos/dos.h>
#include <exec/memory.h>
#include <exec/types.h>
#include <dos/dosextens.h>

/*  -----  DEFINIZIONE STRINGHE PER INFO E PER IL COMANDO C:VERSION  -----  */
UBYTE vers[] = "\0$VER: \033[33m3DIZIO\033[31m Vers. 1.0";
UBYTE uso[] = "\n\033[33m3DIZIO V1.0\033[31m  (c)Maurizio DEEP RED 1996\nSintassi: 3DIZIO nomefile";

/*  -----  DEFINIZIONE PROTOTIPI  -----  */
void Errore(char *);
long CercaChunk(char *, long, long);
void Strutture(int, int, int);
void exit(int);

/*  -----  DEFINIZIONE STRUTTURE  -----  */
struct ChunkHead {
	long Dimens;
	UWORD Numero;
	};

/*  -----  IMPOSTAZIONE STRUTTURE -----  */
struct FileInfoBlock *fib;
struct FileLock *lock, *Lock();
struct FileHandle *filehandle, *PNTS_file, *EDGE_file, *FACE_file, *Open();
struct ChunkHead *PNTS_ind, *EDGE_ind, *FACE_ind;

/*  -----  VARIABILI GLOBALI  -----  */
UWORD PNTS_n, EDGE_n, FACE_n;
char *temp ,*base, *PNTS_base, *EDGE_base, *FACE_base;



	/*  -----------------------------------------------------  *
	 *     ROUTINE  MAIN()                                     *
	 *  -----------------------------------------------------  */
main(int argc, char **argv)
{
	int t;
	int ok, size, size_read;
	long buffer;

	if ((argc==1) || (argv[argc-1][0] == '?')) { printf("%s\n", uso); exit(RETURN_OK); }

	printf("\033[33m3DIZIO V1.0\033[31m  (c)Maurizio Merlo 1995\n\n");

	fib = (struct FileInfoBlock *)AllocMem(sizeof(struct FileInfoBlock), MEMF_CLEAR);
        if (fib == 0) Errore("Non posso allocare memoria!");

	if (lock = Lock(argv[1], SHARED_LOCK))
	{
		if (ok = Examine(lock, fib)) size = fib->fib_Size;
                else Errore("Non posso esaminare il file!");
	}
	else Errore("Non posso accedere al file!");

	printf("\tFile:\t\t%s\n", fib->fib_FileName);
	printf("\tDimensione:\t%d bytes\n", size);

        if (lock) UnLock(lock);
        if (fib) FreeMem(fib, sizeof(struct FileInfoBlock));


        buffer = AllocMem(size, MEMF_CLEAR);
	if (buffer == 0) Errore("Non posso allocare la memoria per il buffer!");

        filehandle = Open(argv[1], MODE_OLDFILE);
        size_read = Read(filehandle, buffer, size);
        if (!(size_read == size)) Errore("Qualcosa non va nella lunghezza del file!");

        if (strcmp("TDDDOBJ ", (char *)(buffer+8))) Errore("\tNon è un file TDDD o non è elaborabile!");
        else printf("\tFormato TDDD ok\n");

        PNTS_ind = CercaChunk("PNTS", buffer, size);
        if (PNTS_ind == 0) Errore("Errore nel file!");
	PNTS_n = PNTS_ind->Numero;
	printf("\tDimens. %d bytes\tNumero %d\n", PNTS_ind->Dimens, PNTS_n);
	PNTS_file = Open("RAM:OBJECT.PNTS", MODE_NEWFILE);
	Write(PNTS_file, PNTS_ind, PNTS_ind->Dimens+4);
	Close(PNTS_file);

        EDGE_ind = CercaChunk("EDGE", buffer, size);
        if (EDGE_ind == 0) Errore("Errore nel file!");
        EDGE_n = EDGE_ind->Numero;
	printf("\tDimens. %d bytes\tNumero %d\n", EDGE_ind->Dimens, EDGE_n);
	EDGE_file = Open("RAM:OBJECT.EDGE", MODE_NEWFILE);
	Write(EDGE_file, EDGE_ind, EDGE_ind->Dimens+4);
	Close(EDGE_file);

        FACE_ind = CercaChunk("FACE", buffer, size);
        if (FACE_ind == 0) Errore("Errore nel file!");
	FACE_n = FACE_ind->Numero;
	printf("\tDimens. %d bytes\tNumero %d\n", FACE_ind->Dimens, FACE_n);
	FACE_file = Open("RAM:OBJECT.FACE", MODE_NEWFILE);
	Write(FACE_file, FACE_ind, FACE_ind->Dimens+4);
	Close(FACE_file);


Fine:
	if (filehandle) Close(filehandle);
	if (buffer) FreeMem(buffer, size);
	exit(RETURN_OK);
}

/*  ----------------------------------  *
 *  STAMPA UN MESSAGGIO DI ERRORE POI   *
 *  ESCE CON FAIL                       *
 *  ----------------------------------  */
void Errore(char *messagg)
{
	printf("\033[33m%s\033[31m\n\n", messagg);
	exit(RETURN_FAIL);
}

/*  ----------------------------------  *
 *  CERCA UN CHUNK ALL'INTERNO DEL 	*
 *  FILE E NE RITORNA L'INDIRIZZO DI    *
 *  PARTENZA                            *
 *  ----------------------------------  */
long CercaChunk(char *parola, long indir, long dimens)
{
	long n;
	int ricerca;
	for (n=0; n < (dimens+1); n++)
	{
		ricerca = strcmp(parola, (char *)(indir + n));
		if (ricerca == 0)
		{
                        printf("\tChunk: %s\tOffset: %d\t", parola, n);
			return(indir+n+4);
		}
        }
	return(0);
}
