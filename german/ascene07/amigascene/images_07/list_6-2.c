/*	Bubblesort */

#include <stdio.h>

typedef int KEY;

#define N 10
KEY a[N]={8,1,9,6,2,4,3,10,7,5};

void Sort(KEY a[],int n)
{
register i;
int vertauscht;
KEY temp;

	do {
		vertauscht=0;
		for(i=0;i<n-1;i++)
			if(a[i]>a[i+1]) {
				temp=a[i];
				a[i]=a[i+1];
				a[i+1]=temp;
				vertauscht=1;
			}
	} while(vertauscht);
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
