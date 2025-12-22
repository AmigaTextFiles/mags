/*	Mergesort */

#include <stddef.h>
#include <stdlib.h>
#include <stdio.h>

typedef int KEY;

#define N 10
KEY a[N]={8,1,9,6,2,4,3,10,7,5};

static KEY *b;
static size_t size;

void Merge(register KEY *a,int l,int m,int r)
{
register i=l;
register j=m+1;
register k=l;

	while(i<=m && j<=r)
		if(a[i]<=a[j])
			b[k++]=a[i++];
		else
			b[k++]=a[j++];
	while(i<=m) b[k++]=a[i++];
	while(j<=r) b[k++]=a[j++];
	for(i=l;i<=r;i++) a[i]=b[i];
}

void MergeSort(KEY *a,int l,int r)
{
int m;

	if(l<r) {
		m=l+r>>1;
		MergeSort(a,l,m);
		MergeSort(a,m+1,r);
		Merge(a,l,m,r);
	}
}

void Sort(KEY a[],int n)
{
	b=malloc(size=sizeof(KEY)*n);
	if(b) {
		MergeSort(a,0,n-1);
		free(b);
	}
}

void main(int argc,char **argv)
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
