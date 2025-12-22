
/* Euclid's Algorithm */

#include <stdio.h>
#include <exec/types.h>

/*
	a,b are initial numbers
	A[] is array to store numbers
	n is counter
*/
ULONG a,b,A[200];
int n;

void main()
{
	do
	{
		printf("Please Enter a Number...\n");
		scanf("%d",&a);
		if (a==0)
			break;
		printf("and Another Number...\n");
		scanf("%d",&b);
		A[0]=a;
		A[1]=b;
		n=0;
	
		do
		{
			if (A[n] % A[n+1] == 0)
				break;
			A[n+2]=A[n] % A[n+1];
			n++;
		} while (1);
		printf("\nThe hcf of %d and %d is %d\n\n",a,b,A[n+1]);
	} while (1);
}
