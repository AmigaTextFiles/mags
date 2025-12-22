#include <stdio.h>

int kvadrat(int n);              /* Deklaracije funkcija  */
int kub(int);                    /* Ocekuju integer i vracaju integer*/ 
int formula(int);                /* Bitno da se poklopi tip, a ime varijabli nije vazno, pa ga ne moramo staviti. Posto su sve funkcije definirane poslije (ispod) poziva moraju se deklarirati */

int ex;                          /* Globalna varijabla, vidljiva u svim funkcijama */

main()
{
	int i=5;                         /* Lokalna varijabla main-a */

	printf( "Unesi vrijednost ex varijable: "); 	        /* Isps teksta */
	scanf( "%d ",&ex);                           		/* smestanje ulaza u ex */
	printf ( "\n Ok. ex=%d  i=%d\n ",ex,i);

	printf( "%d^2=%d\n ",i,kvadrat(i));      
	printf( "%d^3=%d\n ",i,kub(i));
	
	printf( "n^3+6*n^2+4*n=%d\n ",formula(i));
	
	printf( "ex je sada %d\n ",ex);
}

int kvadrat (int n)              /* Definicija - ide bez  ";" !! */
{
	int i;                           /* Lokalna varijabla i - nema veze sa onom iz main-a */

	i=n*n;                           /* i=n^2 */
	return(i);                       /* Vrijednost koju funkcija vraca */
}

int kub (int n)

{
	return (n*n*n);                  /* Moze i ovako*/
}

int formula (int n)         	  	 /* n^3+6n^2+4n  */

{
	int tmp;                         /* Privremena varijabla */

	tmp=kub(n)+6*kvadrat(n)+4*n;     /* Formula. Iz jedne funkcije se mogu pozivati druge. Cak je dozvoljeno da funkcija pozove samu sebe (rekurzija) */
	
	ex=ex+5;                         /* ex je globalna varijabla, pa je svuda mozemo koristiti i mijenjati */

	return(tmp);

}

