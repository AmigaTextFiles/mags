/* ======================================================== *
 * IZIO    ___    TiraGiuIlKickstart.c                      *
 * SOFT   / //                                              *
 * ___   / //     Salva il Kickstart in un file.            *
 * \ \\ / //      Formato immagine e Softkick               *
 *  \ \/ //                                                 *
 *   \__//                        (c)1996 Maurizio DEEP RED *
 *                           SAS/C v6.51 Development System *
 * -------------------------------------------------------- *
 * DATA: Mer 7.02.96                  VER ... 1.0           *
 * S.O. / HW .. 1.3+                  REV ... 0             *
 * NOTE: .........                                          *
 * ======================================================== */


/* ------  FILES DI INCLUDE  ------ */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dos/dos.h>

/* ------  DEFINES  ------ */
#define ROMBASE    0xF80000			/*  Indirizzo di inizio del KickStart		*/
#define DIM256K    0x40000                      /*  Dimensione delle ROM da 256 Kb		*/
#define DIM512K    0x80000                      /*  Dimensione delle ROM da 512 Kb		*/

/* ------  DEFINIZIONE STRUTTURE  ------ */
struct	{                                       /*  Struttura dell' header del file Kickstart	*/
		long Zeri;                      /*  secondo le specifiche Commodore		*/
		long Dimensione;
	} CBM_ROM_FileHeader;

struct FileHandle *filehandle, *Open();         /*  Strutt. FileHandle per il file da scrivere  */

/*  -----  DEFINIZIONE STRINGHE PER INFO E PER IL COMANDO C:VERSION  -----  */
UBYTE vers[] = "\0$VER: TGIKS Vers. 1.0";
UBYTE uso[] = "\n\033[34mTGIKS V1.0  \033[31m(c)Maurizio DEEP RED 1996\nSintassi: TGIKS nomefile [S]";


/* ------  ROUTINE PRINCIPALE  ------ */
main(int argc, char **argv)
{
	BOOL SoftKick = 0;			/*  Scrivi immagine rom oppure rom SoftKick	*/
	long id1 = 0x11114EF9;                  /*  1a long all' indirizzo ROMBASE per 256 Kb   */
        long id2 = 0x11144EF9;                  /*  1a long all' indirizzo ROMBASE per 512 Kb   */
        int dim_rom;				/*  Dimensione del Kickstart Installato		*/
	int dim_file;				/*  Dimensione del file kickstart scritto	*/

	if ((argc==1) || (!(strcmp(argv[1], "?")))) { printf("%s\n", uso); exit(RETURN_OK); }
	printf("\n\033[34mTiraGiùIlKickStart V1.0  \033[31m\n(c)IZIOSOFT - Maurizio Merlo 1996\n");
	if ((argc==3) && (!(strcmp(argv[2], "S")))) SoftKick = 1;

	if (memcmp(ROMBASE, &id1, 4) == 3) dim_rom = DIM512K;	/*  Controllo dimensione ROM	*/
	if (memcmp(ROMBASE, &id1, 4) == 0) dim_rom = DIM256K;

	printf("Dimensione delle ROM: %d bytes\n", dim_rom);

       	filehandle = Open(argv[1], MODE_NEWFILE);
	if (filehandle == 0)
	{
		printf("\n\nNon posso aprire il file!!\n");
		exit(RETURN_FAIL);
	}

	if (SoftKick)
	{
		CBM_ROM_FileHeader.Zeri = (long)0;
		CBM_ROM_FileHeader.Dimensione = dim_rom;
        	printf("Salvataggio del KickStart come SoftKick File\n");
		Write(filehandle, &CBM_ROM_FileHeader, 8);
	}

	dim_file = Write(filehandle, ROMBASE, dim_rom);

	printf("...OK!\n");
	Close(filehandle);
	exit(RETURN_OK);
}