/*	Heapsort */

#include <stdio.h>

typedef int KEY;

#define N 10
KEY heap[N]={1,2,4,8,3,5,6,10,9,7};	/*Ein gültiger Heap!!!*/

void versickere(register KEY a[],int n)
{
register i=0,j;
KEY t;

	while((j=(i+1<<1)-1)<n)
	{
		if(j<n-1 && a[j]>a[j+1]) j++;
		if(a[i]>a[j])
		{
			t=a[i];
			a[i]=a[j];
			a[j]=t;
			i=j;
		}
		else break;
	}
}

void Sort(KEY a[N],int n)
{
register i;
KEY t;

	for(i=n-1;i>=0;i--) {
		t=a[i];
		a[i]=a[0];
		a[0]=t;
		versickere(a,i);
	}
}

void main()
{
int i;

	printf("Heap:\n");
	for(i=0;i<N;i++) printf("%d ",heap[i]);
	putchar('\n');
	Sort(heap,N);
	printf("Sortierte Liste:\n");
	for(i=0;i<N;i++) printf("%d ",heap[i]);
	putchar('\n');
}
