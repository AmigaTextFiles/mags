/*	Sortieren durch Auswahl */

#include <stdio.h>

typedef int KEY;

#define N 10
KEY a[N]={8,1,9,6,2,4,3,10,7,5};

void Sort(KEY a[],int n)
{
register i,j;
int min;
KEY temp;

	for(i=0;i<n-1;i++) {
		min=i;
		for(j=i+1;j<n;j++)
			if(a[j]<a[min]) min=j;
		temp=a[min];
		a[min]=a[i];
		a[i]=temp;
	}
}

void main()
{
int i;

	printf("Unsortierte Liste:\n");
	for(i=0;i<N;i++) printf("%d ",a[i]);
	putchar('\n');
	Sort(a,N);
	printf("Sortierte Liste:\n");
	for(i=0;i<N;i++) printf("%d ",a[i]);
	putchar('\n');
}