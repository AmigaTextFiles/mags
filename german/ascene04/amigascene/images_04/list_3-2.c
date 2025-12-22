/* AVL-Baum */
/* Mit Listing 1 aus dem 2. Kursteil (LIFO-Stack) linken */

#include <stdlib.h>
#include "list_2-1.h"

struct avl_node {
	struct avl_node *left,*right;
	char bal;
};

typedef int (*avlcmp)(const struct avl_node *,const struct avl_node *);

struct avl {
	struct avl_node *root;
	avlcmp cmp;
};

#define key2avl(key) ((struct avl_node *)((char*)(key)-sizeof(struct avl_node)))

static struct lifo stack={ NULL,
	sizeof(struct avl_node*),
	50*sizeof(struct avl_node*)
};

	/*Der Constructor*/

avl(struct avl *this,avlcmp f)
{
	this->root=NULL;
	this->cmp=f;
	return 0;
}

	/********************************************************
	 * Funktionen für die Rotationen ab einem best. Knoten. *
	 * Giben neuen Zeiger zurück, der anstatt des alten     *
	 * zu verwenden ist.                                    *
	 ********************************************************/

static struct avl_node *LinksRotation(struct avl_node *n)
{
struct avl_node *t=n->right;

	n->right=t->left;
	n->bal=0;
	t->left=n;
	t->bal=0;
	return t;
}

static struct avl_node *RechtsRotation(struct avl_node *n)
{
struct avl_node *t=n->left;

	n->left=t->right;
	n->bal=0;
	t->right=n;
	t->bal=0;
	return t;
}

static struct avl_node *LinksRechtsRotation(struct avl_node *n)
{
struct avl_node *t=n->left;
int b=t->right->bal;

	n->left=LinksRotation(t);
	t->bal=b>0?-1:0;
	t=RechtsRotation(n);
	n->bal=b<0?1:0;
	return t;
}

static struct avl_node *RechtsLinksRotation(struct avl_node *n)
{
struct avl_node *t=n->right;
int b=t->left->bal;

	n->right=RechtsRotation(t);
	t->bal=b<0?-1:0;
	t=LinksRotation(n);
	n->bal=b>0?1:0;
	return t;
}

	/********************************************************
	 * Sucht im angegebenen Baum einen Knoten, der zu n		*
	 * äquivalent ist. Gibt Zeiger auf diesen oder NULL		*
	 * zurück (NULL=nicht vorhanden).								*
	 * Legt Suchpfad auf den Stapel "stack" ab.					*
	 ********************************************************/

struct avl_node *avl_find(struct avl *this,const struct avl_node *n)
{
struct avl_node *an;
int result;

	an=this->root;								/*beginne bei der Wurzel.*/
	clear(&stack);								/*setze Stapel für Pfad zurück.*/
	while(an) {									/*Bis zum Baumende.*/
		result=this->cmp(n,an);				/*Vergleich durchführen.*/
		if(result==0) break;					/*Knoten gefunden: Ende.*/
		push(&stack,&an);						/*Merke Knoten in Pfad-Stapel.*/
		if(result<0) an=an->left;			/*Steige je nach Vergleich nach*/
		else an=an->right;					/*links oder rechts runter.*/
	}
	return an;
}

static int goup;

	/***************************************************
	 * Fügt in den angeg. Baum den angeg. Knoten ein.	*
	 * Gibt NULL zurück, wenn alles OK, sonst einen		*
	 * Zeiger auf einen Knoten der denselben Schlüssel	*
	 *	hat, wie der angegebene. In diesem Fall wird		*
	 * der angeg. Knoten NICHT in den Baum eingefügt.	*
	 ***************************************************/

struct avl_node *avl_insert(struct avl *this,struct avl_node *n)
{
struct avl_node *an,*new_node;

	n->bal=0;									/*Knoten initialisieren.*/
	n->left=n->right=NULL;

	if((an=avl_find(this,n))==NULL) {	/*Suche Knoten im Baum.*/

		if(!isempty(&stack)) {				/*Wenn Baum nicht leer, n einfügen.*/
			an=*(struct avl_node **)top(&stack);	/*Vater von n.*/
			if(this->cmp(n,an)<0) an->left=n;		/*links oder rechts.*/
			else an->right=n;
		}

		new_node=n;
		for(goup=1;;) {						/*Steige wieder zurück hinauf.*/
			if(!pop(&stack,&an)) {			/*Hole nächsthöheren Knoten.*/
				this->root=new_node;			/*Wenn Stapel zu Ende, dann neue*/
				break;							/*Wurzel setzen und beenden.*/
			}
			if(an->left==n) {					/*Wir kamen von links.*/
				an->left=new_node;			/*Neuen Knoten (wegen mgl. Rot.)*/
				if(!goup) break;				/*schon fertig, dann raus.*/
				n=an;								/*Vergleichsknoten für nächstesmal.*/
				switch(an->bal) {				/*behandle je nach Balance.*/
					case  1: an->bal=goup=0;break;
					case  0: an->bal=-1;break;
					case -1:
						if(an->left->bal==-1) an=RechtsRotation(an);
						else an=LinksRechtsRotation(an);
						goup=0;
						break;
				}
			}
			else {								/*Wir kamen von rechts.*/
				an->right=new_node;
				if(!goup) break;
				n=an;
				switch(an->bal) {
					case -1: an->bal=goup=0;break;
					case  0: an->bal=1;break;
					case  1:
						if(an->right->bal==1) an=LinksRotation(an);
						else an=RechtsLinksRotation(an);
						goup=0;
						break;
				}
			}
			new_node=an;						/*neuer Sohn für nächsthöhere Node.*/
		}
		an=NULL;
	}
	return an;
}



	/***************************************************
	 * leftRemoved und rightRemoved behandeln einen    *
	 * Knoten "n", dessen linker oder rechter Teilbaum *
	 * in der Höhe gefallen ist.                       *
	 ***************************************************/

static struct avl_node *leftRemoved(register struct avl_node *n)
{
	switch(n->bal) {					/*je nach bisheriger Balance:*/
		case -1: n->bal=0;break;
		case  0: n->bal=1;goup=0;break;
		case  1:
			switch(n->right->bal) {
				case  1:
					n=LinksRotation(n);
					break;
				case  0:
					n=LinksRotation(n);
					goup=0;
					n->bal=-1;
					n->left->bal=1;
					break;
				case -1:
					n=RechtsLinksRotation(n);
					break;
			}
			break;
	}
	return n;
}

static struct avl_node *rightRemoved(register struct avl_node *n)
{
	switch(n->bal) {
		case  1: n->bal=0;break;
		case  0: n->bal=-1;goup=0;break;
		case -1:
			switch(n->left->bal) {
				case -1:
					n=RechtsRotation(n);
					break;
				case  0:
					n=RechtsRotation(n);
					goup=0;
					n->bal=1;
					n->right->bal=-1;
					break;
				case  1:
					n=LinksRechtsRotation(n);
					break;
			}
			break;
	}
	return n;
}

struct avl_node *avl_remove(struct avl *this,struct avl_node *n)
{
struct avl_node *rem_node,				/*zu entfernender Knoten.*/
	*sym_node,								/*ev. symmetrischer Nachfolger.*/
	*old_node,								/*alter Knoten auf Pfad, ist durch*/
	*new_node;								/*neuen Knoten zu ersetzen, da durch*/
												/*Rotationen Änderungen möglich.*/
int sym_nf_used=0;						/*Merker, ob symm. Nachfolger benützt.*/
															/*Suche zu entf. Knoten.*/
	if((old_node=rem_node=avl_find(this,n))!=NULL) {
		if(rem_node->left==NULL && rem_node->right==NULL)
			new_node=NULL;								/*Blatt!*/
		else if(rem_node->left==NULL)
			new_node=rem_node->right;				/*nur rechter Sohn.*/
		else if(rem_node->right==NULL)
			new_node=rem_node->left;				/*nur linker Sohn.*/
		else {											/*zwei Söhne.*/
			old_node=rem_node;						/*rem_node=zu entf. Knoten.*/
			push(&stack,&rem_node);					/*lege ihn auf den Stack.*/
			sym_node=rem_node->right;				/*suche den symmetrischen*/
			while(sym_node->left) {					/*Nachfolger und merke auch*/
				push(&stack,&sym_node);				/*dessen Vater in old_node.*/
				old_node=sym_node;
				sym_node=sym_node->left;
			}
			if(old_node!=rem_node)
				old_node->left=sym_node->right;	/*symm. Nachfolger von dessen*/
			else											/*Vater abhängen.*/
				old_node->right=sym_node->right;

			old_node=sym_node->right;				/*Ersatz für symm. Nachfolger.*/
			*sym_node=*rem_node;						/*Knoten-Link/Bal. kopieren.*/
			new_node=old_node;
			sym_nf_used=1;								/*merke: d. sym. Nf. ersetzen.*/
		}
		for(goup=1;;) {								/*Rückverfolgungsschleife.*/
			if(!pop(&stack,&n)) {					/*Hole nächsthöheren Knoten.*/
				this->root=new_node;					/*Kein nächsthöherer mehr da,*/
				break;									/*Wurzel setzen und Ende.*/
			}												/*Wenn der zu entfernende*/
			if(n==rem_node)	{						/*Knoten vom Stack kam, dann*/
				n=sym_node;								/*ersetze ihn durch symm. Nf.*/
				sym_nf_used=2;							/*merke, daß gerade behandelt.*/
			}
			if(n->left==old_node) {					/*Wenn wir von links kamen.*/
				n->left=new_node;						/*Neue Verkettung setzen.*/
				if(!goup) {								/*u.U. Balancierung beenden.*/
					if(!sym_nf_used) break;
					new_node=n;
				}
				else new_node=leftRemoved(n);		/*mgl. Balance-Korrektur.*/
			}
			else {										/*dasselbe für rechts.*/
				n->right=new_node;
				if(!goup) {
					if(!sym_nf_used) break;
					new_node=n;
				}
				else new_node=rightRemoved(n);
			}
			if(sym_nf_used==2) {						/*Wenn gerade symm. Nf. ein-*/
				n=rem_node;								/*gesetzt, dann setze n auf*/
				sym_nf_used=0;							/*alten Wert und Merker zurück*/
			}
			old_node=n;									/*Knoten zum Feststellen, ob*/
		}													/*von links oder rechts gek.*/
	}
	return rem_node;									/*entfernter Knoten zurück.*/
}


	/*Beispiel*/

struct test {
	struct avl_node node;
	int key;
};

intcmp(const struct avl_node *t1,const struct avl_node *t2)
{
	return ((const struct test *)t1)->key-((const struct test *)t2)->key;
}

struct avl baum;

void main(int argc,char **argv)
{
int i;
struct test n[7],template,*p;

	avl(&baum,intcmp);
	for(i=0;i<7;i++)
	{
		n[i].key=i+1;
		avl_insert(&baum,(struct avl_node *)&n[i]);
	}
	template.key=5;
	p=(struct test *)avl_remove(&baum,(struct avl_node *)&template);
	/*p enthält nun Zeiger auf n[4], n[4] wurde entfernt.*/
}
