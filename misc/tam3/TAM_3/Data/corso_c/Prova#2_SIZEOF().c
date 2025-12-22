/*   Il mio secondo programma in C: le varabili. Si va sul difficile...  */

/*   25/12/1994    */

#include <stdio.h>

/*  Le variabili vanno definite prima del blocco main()    */

char a;			/*   Variabile di tipo carattere. Fin qui è facile... 	1 Byte	    */
unsigned char b;	/*   Variabile di tipo carattere e senza segno		1 Byte      */
int c;			/*   Variabili di tipo intero;                          4 Bytes     */
unsigned int d; 	/*   Variabile di tipo intero e senza segno             4 Bytes     */
short e;		/*   Variabile di tipo short				2 Bytes	    */
unsigned short f;	/*   Variabile di tipo short e senza segno              2 Bytes     */
double g;		/*   Variabile di tipo double				8 Bytes	    */
float h;		/*   Variabile di tipo float				4 Bytes	    */


void main(void)
{
	printf("\nVediamo un po' le variabili...(quanti tipi!)\n\n");

	a = -128;               /*   Questo è il limite (+/-)                      */
	printf("Dimens. di char:	%d Bytes\n", sizeof(char));
	printf("char		a = %d\n\n", a);

	b = 255;                /*   Questo è il limite sup.; quello inf. è 0	   */
	printf("Dim. di unsigned char:	%d Bytes\n", sizeof(unsigned char));
	printf("unsigned char	b = %u\n\n", b);

        c = -2147483648;	/*   Questo è il limite (+/-)                      */
	printf("Dimens. di int: 	%d Bytes\n", sizeof(int));
	printf("int		c = %d\n\n", c);

	d = 4294967295;		/*   Questo è il limite sup.; quello inf. è 0      */
	printf("Dim. di unsigned int:	%d Bytes\n", sizeof(unsigned int));
	printf("unsigned int	d = %u\n\n", d);

        e = -32768;		/*   Questo è il limite (+/-)                      */
	printf("Dim. di short:		%d Bytes\n", sizeof(short));
	printf("short		e = %d\n\n", e);

	f = 65535;   		/*   Questo è il limite sup.; quello inf. è 0      */
	printf("Dim. di unsigned short:	%d Bytes\n", sizeof(unsigned short));
	printf("unsigned short:	f = %u\n\n", f);

	g = 1e+308;		/*   Questo è il limite (+/-)			   */
	printf("Dim. di double:		%d Bytes\n", sizeof(double));
	printf("double		g = %e\n\n", g);

	h = 1e+38;              /*   Questo è il limite (+/-)			   */
	printf("Dim. di float:		%d Bytes\n", sizeof(float));
	printf("float		h = %e\n\n", h);
}
