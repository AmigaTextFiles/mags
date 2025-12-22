#include <stdio.h>
#include <stdlib.h>
main()
{
        int *p;
        int i;
        if(p=malloc(50*sizeof(int)))
        {
            for (i=0;i<50;i++)
            printf ("%d,",p[i]);
            printf("\n");
            free(p);
        }
}
