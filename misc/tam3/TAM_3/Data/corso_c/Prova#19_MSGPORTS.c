/*  19mo programma: PORTE DI MESSAGGI   */

/*  3/1/95   */


#include <stdio.h>
#include <exec/types.h>
#include <exec/ports.h>


main()
{
	struct Message *m;      /*  Puntatore al messaggio che passerà			*/
				/*  (c'è una struttura Message all' indirizzo *m)	*/
	struct Message *msg;	/*  Puntatore al messaggio che verrà restituito		*/
	struct Message *GetMsg();

	struct MsgPort *mp;     /*  Puntatori alle porte di messaggio			*/
	struct MsgPort *rp,
        struct MsgPort *CreatePort();

	mp = CreatePort(0, 0);
	if (mp == 0) exit(20);

	rp = CreatePort("Reply", 0);
	if (rp == 0)
	{
		DeletePort(mp);
	}

	m->mn_Node.ln_Name = "Ciao a tutti!\n";
	m->mn_ReplyPort = rp;	/*  a chi è inviata			*/
	m->mn_Lenght = 0;

	PutMsg(mp, &m); 	/*  Invia il messaggio m alla porta mp	*/
	WaitPort(mp);		/*  Aspetta che mp riceva il messaggio	*/



	/*   Ha ricevuto il messaggio   */

	while(msg = GetMsg(mp))
	{
		printf("\nIl messaggio era %ls\n", msg->mn_Node.ln_Name);
		ReplyMsg(msg);  /*  risponde al messaggio alla porta di risposta	*/
	}

	WaitPort(rp);	/*  Aspetta che rp riceva la risposta				*/

	while(msg = GetMsg(rp))
	{
		printf("\nLa porta di risposta ha ricevuto %ls", msg->mn_Node.ln_Name);
	}

	DeletePort(mp);
	DeletePort(rp);
}