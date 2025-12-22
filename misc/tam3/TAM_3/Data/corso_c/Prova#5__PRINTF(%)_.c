/*   Quinto programma in C: Printf() e variabili   */

/*   28/12/1994    */

#include <stdio.h>
#include <string.h>

int ivar	= -123;
unsigned uvar   = 34567;
long lvar	= 123567;
char cc		= 'A';
float fvar   = 1.1414213562;
char cstring[10];

main()
{
	printf("\n%c", cc);
	printf("\n%d %06d 0x%x 0%o", ivar, ivar, ivar, ivar);
        printf("\n%u %07u 0x%x 0%o", uvar, uvar, uvar, uvar);
	printf("\n%ld 0x%09lx 0%010lo", lvar, lvar, lvar);
	printf("\n%f %e %g", fvar, fvar, fvar);
	strcpy(cstring, "Ciaoo!");
	printf("\n%s", cstring);
	printf("\n%10s", cstring);
}
