#include <stdio.h>
main()
{
	int niz[]={5,2,7,77,4,32,66,43,0,0,0};
	int i=0;
	while (niz[i]!=0)
		i++;
	printf("Prva %d elemenata nisu nule.\n",i);
}
