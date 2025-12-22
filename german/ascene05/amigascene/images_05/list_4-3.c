/*Bsp. f. trivialen Suchalgorithmus*/
/*(absichtlich ohne string.h-Funktionen)*/

#include <stdio.h>

char *suche(char *text,register char *muster)
{
register i=0;
register char *t;

	for(t=text;t[i];t++) {
		for(i=0;muster[i];i++)
			if(t[i]!=muster[i]) break;
		if(!muster[i])
			return t;
	}
   return NULL;
}

static char text[]={"halihalihalo!"};
static char muster[]={"halihalo"};

void main()
{
char *cp;

	cp=suche(text,muster);
	if(cp) printf("Gefunden an Position %d.\n",cp-text);
	else printf("Nicht gefunden.\n");
}
