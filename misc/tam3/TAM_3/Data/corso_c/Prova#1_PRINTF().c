/*   Il mio primo programma in C.... (e tre!...)   */

/*   22/12/1994    */


#include <stdio.h>

main()
{
	printf("Provo ad usare il comando PRINTF()...\n");
	printf("Funziona? forse...\n\n");
	printf("\tQuesto è un TAB\n");
	printf("\t\tNoi siamo due TAB...\n");                        	/*   \t = TABulazione      */
	printf("CIAO\b ...ho cancellato un carattere indietro\n");   	/*   \b = Backspace        */
	printf("         Return\rCarriage\n");                       	/*   \r = CR               */
	printf("Caratteri vari:  \255\254\253\252\251\250\n");       	/*   \nASCII = Carattere   */
	printf("Emetto un beep...\7\n");                  		/*   \7 = beep		   */
	printf("(2+(2*3))/4 = %d\n", (2+(2*3))/4);		     	/*   Operazioni di base	   */
}
