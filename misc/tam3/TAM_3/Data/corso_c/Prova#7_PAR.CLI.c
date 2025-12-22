/*  Settimo programma: passaggio parametri da CLI  */

/*  27/12/1994  */


#include <stdio.h>

main(argc,argv)
int argc;
char **argv;
{
	int j;
	for (j=0; j<argc; j++)
	{
		printf("Il numero dell' argomento %d è %s\n", j, argv[j]);
	}
}