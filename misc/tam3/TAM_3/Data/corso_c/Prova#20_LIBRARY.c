/*  20mo programma Apertura di una libreria  */

/*  3/1/1995	*/

#include <stdio.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>

struct Library *OpenLibrary();
struct IntuitionBase *IntuitionBase;


main()
{
	IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library",0);
	if (IntuitionBase == 0)
	{
		printf("Non posso aprire la libreria!");
		exit(20);
	}
	else
	{
                printf("Ho aperto la libreria!");
	}

        CloseLibrary(IntuitionBase);
}
