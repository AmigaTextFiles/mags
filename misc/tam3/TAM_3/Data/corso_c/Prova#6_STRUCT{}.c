/*   Sesto programma in C: Strutture   */

/*   28/12/1994    */

#include <stdio.h>
#include <string.h>

char *pnome;

main()
{

	struct
	{
		char cogn[20];
		char nome[20];
	} nome1, *pnome;

        pnome = &nome1;

	strcpy(nome1.cogn, "Merlo");               /*  Se si usa il nome della struttura: "."   */
	strcpy(pnome->nome, "Maurizio");           /*  Se si usa il puntatore:	"->"            */

	printf("\nCon .  %s %s", nome1.nome, nome1.cogn);
	printf("\nCon -> %s %s", pnome->nome, pnome->cogn);


}
