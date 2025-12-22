/* Quicksort */

#include <stdio.h>

typedef int KEY;

#define N 10
KEY a[N]={8,1,9,6,2,4,3,10,7,5};

void Quick(KEY a[],int l,int r)
{
register i,j;
KEY k,temp;

	if(r>l) {
		i=l-1;
		j=r;
		k=a[r];
		for(;;) {
			do i++;
			while(a[i]<k);
			do if(--j<0) break;
			while(a[j]>k);
			if(i>=j) break;
			temp=a[i];
			a[i]=a[j];
			a[j]=temp;
		}
		temp=a[i];
		a[i]=a[r];
		a[r]=temp;
		Quick(a,l,i-1);
		Quick(a,i+1,r);
	}
}

void Sort(KEY a[],int n)
{
	Quick(a,0,n-1);
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
