/*  18mo programma: LISTE  */

/*  3/1/95   */


#include <stdio.h>
#include <exec/types.h>
#include <exec/lists.h>

struct MyListItem                    /*  Definisce com'è composto un "item" della lista  */
{
	struct Node n;
	char *data;
};


main()
{
	struct MyListItem mli[3];    /*  Definisce 3 "item" in una matrice  		*/
                                     /*  ora ci sono 3 strutture ...			*/

	struct MyListItem *mynode;   /*  mynode punta all' indirizzo di una MyListItem 	*/

	struct List MyListHead;      /*  Definisce una struttura di tipo 'List' 	*/
                                     /*  che rappresenta l'intestazione della lista	*/
                                     /*  che verrà creata (è la lista vuota)		*/
	int i;

	NewList(MyListHead);         /*  Crea la lista partendo dalla definizione data	*/
                                     /*  prima con il comando 'struct List...'		*/

	/*  Ora la lista c'è, ma è vuota. Mettiamo qualcosa...	(aggiungiamo items)	*/
	/*  Diamo un valore ai data nelle tre strutture che sono i ostri item		*/

	mli[0].data = "ciao, io sono il primo";
	mli[1].data = "io sono il secondo";
	mli[2].data = "e io sono il terzo...";

        for(i=0; i<3; i++)
	{
		printf("\n%ls", mli[i].data);
	}

	AddTail(MyListHead, &mli[1]);
	AddTail(MyListHead, &mli[2]);
	AddTail(MyListHead, &mli[3]);

	/*  Adesso la lista ha 3 item oltre all'intestazione */

}
