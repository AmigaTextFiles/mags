/*	Textsuche nach dem Verfahren von Knuth-Morris-Pratt */

#include <stdlib.h>
#include <string.h>

	/*Die benützte Struktur:*/

struct kmp {
	int *next;		/*Das im Text beschriebene next-Feld.*/
	int len;			/*Länge des musters.*/
	const char *muster;	/*Der Suchtext.*/
};

	/***********************************
	 * Der Konstruktor c_muster unter- *
	 * sucht das angegebene Muster s   *
	 * auf Präfixstrings und danach	   *
	 * initialisiert er das Objekt.    *
	 * (insbesondere dessen next-Feld) *
	 ***********************************/

int c_muster(struct kmp *this,char *s)
{
register i,j;

	this->muster=s;
	this->len=strlen(s);					/*Merke das Muster und dessen Länge.*/
	this->next=malloc((this->len+1)*sizeof(int));
	if(this->next==NULL) return 0;	/*Erzeuge next-Feld für Präfixmerker.*/
	this->next[i=0]=j=-1;				/*Setze Merker für Feldanfang (-1).*/
	do {										/*Solange Übereinstimmung mit dem*/
		if(j<0 || s[i]==s[j])			/*Musteranfang und nicht Feldanfang,*/
			this->next[++i]=++j;			/*nächstes Feld um 1 erhöht.*/
		else j=this->next[j];			/*sonst auf aktuellen Anfang zurück.*/
	} while(s[i]);							/*Bis das Musterende erreicht ist.*/
	return 1;
}

	/*Destruktor: Gibt den durch c_muster belegten Speicher wieder frei.*/

void d_muster(struct kmp *this)
{
	if(this->next) free(this->next);
}

	/**************************************
	 * search sucht im angegebenen Text   *
	 * das zuvor dem Objekt zugewiesene   *
	 * Muster und gibt einen Zeiger auf   *
	 * die Stelle in cp zurück, an der    *
	 * das Muster gefunden werden konnte. *
	 * Bei Mißerfolg erhält man NULL.     *
	 **************************************/

char *search(register struct kmp *this,register char *cp)
{
register j;
char c=0;

	if(!this->next) return NULL;		/*Wenn kein Muster angegeben, Ende.*/
	j=-1;										/*Index ins Muster-Feld (Neubeginn).*/
	for(;;)									/*Bis Ende od. gefunden: Wenn*/
		if(j<0 || c==this->muster[j]) {	/*Übereinstimmung oder Neubeginn:*/
			if(++j==this->len)			/*nächstes Zeichen im Muster nehmen.*/
				break;						/*Wenn schon genug verglichen->gef.*/
			if(!(c=*cp++))					/*Neues Zeichen holen, bis das*/
				return NULL;				/*Stringende erreicht ist.*/
		}
		else j=this->next[j];			/*bei Mismatch: neue Mustervergl.-pos.*/

	return cp-this->len;					/*Beginn um Musterlänge weiter vorn.*/
}


	/*Beispiel*/

#include <stdio.h>

char text[]={"halihalihalo"};	/*Fließtext*/
char such[]={"halihalo"};		/*Suchtext*/

void main(int argc,char **argv)
{
struct kmp k;
char *cp;

	if(!c_muster(&k,such)) {			/*Initialisiere Objekt mit Suchtext.*/
		fprintf(stderr,"Speicher voll.\n");
		exit(10);
	}
	cp=search(&k,text);					/*Suche im String >text<.*/
	if(cp) printf("Gefunden an Position %d.\n",cp-text);
	else printf("Nicht gefunden.\n");

	d_muster(&k);							/*Brauche k ab hier nicht mehr.*/
}
