/* Operatoren für Binärbaum */

#include <stddef.h>

	/* Definition eines Knotens des Binärbaumes.*/

struct tree_node {
	struct tree_node *left,*right;
};

	/* Definition der Vergleichsfunktion.*/

typedef int (*treecmp)(const struct tree_node *,const struct tree_node *);

	/* Definition der Baumstruktur selbst.*/

struct tree {
	struct tree_node *root;
	treecmp cmp;
};

	/*Makro zur Umwandlung eines Schlüssels in einen Knoten.*/

#define key2node(key) ((struct tree_node *)((char)key-sizeof(struct tree_node)))



/*
	Konstruktor - muß für jeden Baum vor Verwendung aufgerufen werden.
	An ihn sind der Baum und ein Zeiger auf die Vergleichsfunktion,
	die vom Typ treecmp sein muß, zu übergeben.
*/

tree(struct tree *this,treecmp f)
{
	this->root=NULL;			/*Baum anfangs leer.*/
	this->cmp=f;				/*Vergleichsfunktion.*/
	return 0;
}

/*
	Die Suchfunktion. Erhält einen Zeiger auf den zu durchsuchenden
	Baum und den gesuchten Knoten. Oft soll nur der Schlüssel angeg.
	werden, dann ist das Makro key2node zu benützen.
	Gibt Pointer auf gesuchten Knoten zurück oder NULL, wenn nichts
	gefunden.
	Außerdem wird die globale Variable father auf den Vater des gef.
	Knotens gesetzt.
*/

static struct tree_node *father;

struct tree_node *tree_find(struct tree *this,struct tree_node *n)
{
register struct tree_node *tn;
int result;

	father=NULL;				/*father vorbesetzen.*/
	tn=this->root;				/*beginnen bei Wurzel.*/
	while(tn) {				/*bis zum Baumende.*/
		result=this->cmp(n,tn);		/*Vergleich durchführen.*/
		if(result==0) break;		/*Übereinstimmung!*/
		father=tn;			/*sonst Vater des nächsten.*/
		if(result<0) tn=tn->left;	/*je nach Vergleichswert*/
		else tn=tn->right;		/*links oder rechts.*/
	}
	return tn;
}

/*
	Fügt den Knoten n in den Baum this ein. Die Suchbäume sind nur
	für explizite Schlüssel ausgelegt. Wenn der Knoten n also den
	gleichen Schlüssel hat wie ein bereits bestehender Knoten,
	dann wird die Adresse des äquivalenten Knotens im Baum
	zurückgegeben und n NICHT eingefügt.
	Ansonsten gibt tree_insert NULL zurück.
*/

struct tree_node *tree_insert(struct tree *this,struct tree_node *n)
{
struct tree_node *tn;
int result;

	n->left=n->right=NULL;			/*Knoten initialisieren.*/
	if(this->root==NULL) {			/*Wenn Baum bisher leer:*/
		this->root=n;			/*n ist neue Wurzel.*/
		return NULL;
	}
	if((tn=tree_find(this,n))!=NULL)	/*Suche Einfügeposition.*/
		return tn;			/*Schlüssel schon vorhanden*/

	result=this->cmp(n,father);		/*Links oder rechts rein?*/
	if(father==NULL) {			/*n wird neue Wurzel.*/
		if(result<0) this->root->left=n;
		else this->root->right=n;
		this->root=n;
	} else {				/*je nach Vergleich*/
		if(result<0) father->left=n;	/*links oder rechts rein.*/
		else father->right=n;
	}
	return NULL;
}

/*
	Entfernt einen Knoten aus dem Baum dessen Schlüssel mit dem
	im angeg. Knoten n übereinstimmt. n ist KEIN Zeiger auf einen
	Knoten im Baum sondern nur ein Beispielknoten (wie bei find).
	Ist nur der gesuchte Schlüssel bekannt, ist wiederum
	das Makro key2node zu verwenden.
*/
static void tree_rem(struct tree *,struct tree_node *);

struct tree_node *tree_remove(struct tree *this,struct tree_node *n)
{
register struct tree_node *tn;

	tn=tree_find(this,n);			/*Suche entspr. Knoten.*/
	if(tn) tree_rem(this,tn);		/*Wenn gef., entfernen.*/
	return tn;
}

/*	erledigt das eigentliche Entfernen des Knotens tn, der
	ein Zeiger auf einen Knoten im Baum ist. Erwartet dessen
	Vater in father (oder NULL, wenn tn die Wurzel ist).
*/

static void tree_rem(struct tree *this,struct tree_node *tn)
{
struct tree_node *n1,*n2,*v;

	v=father;				/*Merke Vater.*/
	if(tn->left==NULL && tn->right==NULL) n1=NULL;	/*Blatt!*/
	else if(tn->left==NULL) n1=tn->right;		/*Rechts 1 Sohn.*/
	else if(tn->right==NULL) n1=tn->left;		/*Links 1 Sohn.*/
	else {					/*Zwei Söhne.*/
		n1=tn->right;			/*Suche symm. Nachfolger.*/
		n2=NULL;			/*Merke auch dessen Vater.*/
		while(n1->left) {		/*Immer nach links.*/
			n2=n1;
			n1=n1->left;
		}
		father=n2?n2:tn;		/*Vater von n1.*/
		tree_rem(this,n1);		/*Entferne n1 (rekursiv).*/
		*n1=*tn;			/*Kopiere Linkinfo aus tn.*/
	}
						/*Hänge nun n1 statt tn an.*/
	if(v) {					/*Wenn ein Vater existiert:*/
		if(v->left==tn) v->left=n1;	/*Ersetze tn durch n1 bei*/
		else v->right=n1;		/*diesem.*/
	}
	else this->root=n1;			/*Sonst ist n1 neue Wurzel.*/
}
