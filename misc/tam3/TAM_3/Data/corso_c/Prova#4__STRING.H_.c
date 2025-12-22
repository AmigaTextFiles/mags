/*   Quarto programma in C: stringhe e le principali funzioni relative   */

/*   27/12/1994    */

#include <stdio.h>
#include <string.h>	/*   Si deve includere per le funzioni di stringa	*/
#include <ctype.h>

char stringa1[20];	/*   Questa è la definizione di una stringa		*/
char stringa2[20];
char carattere;

main()
{


	printf("\nImmetti una stringa: ");
	gets(stringa1);		/* chiede l'immissione di una frase	*/
	printf("\n\nHai immesso: %s\n", stringa1);
        printf("E' lunga %d caratteri\n", strlen(stringa1));

        strcpy(stringa2, stringa1);
	printf("\nL'ho copiata in un'altra stringa: 	%s\n", stringa2);

	strcpy(stringa2,"                    ");
	strncpy(stringa2, stringa1, 5);
	printf("\nNe copio solo 5 caratteri:		%s\n", stringa2);

        printf("\n\nImmetti un carattere: ");
	scanf("%s",&carattere);

	if isdigit(carattere) printf("è un numero\n");
	if isascii(carattere) printf("è un carattere ASCII\n");
	if isspace(carattere) printf("è uno spazio\n");
	if islower(carattere) printf("è minuscolo; Maiuscolo %s\n", toupper(carattere));
      	if isupper(carattere) printf("è maiuscolo; Minuscolo %s\n", tolower(carattere));
	if isxdigit(carattere) printf("è esadecimale\n");


}
