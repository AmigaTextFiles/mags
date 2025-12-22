/*Binäre Suche*/

#include <stdio.h>

int liste[]={1,3,5,6,7,10,21,23,34,50};

int *binsearch(int k,int r)
{
int m,l;

	l=1;
	do {
		m=l+r>>1;
		if(k<liste[m-1]) r=m-1;
		else l=m+1;
	} while(k!=liste[m-1] && r>=l);
	return k==liste[m-1]?&liste[m-1]:NULL;
}

void main()
{
int *ip;

	ip=binsearch(23,10);
	if(ip) printf("%d gefunden!\n",*ip);
	else printf("nicht gefunden!\n");
}
