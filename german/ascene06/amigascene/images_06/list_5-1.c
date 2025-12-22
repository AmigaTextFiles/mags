/*
	Beispiel einer Hashtabelle mit Verkettung
	der Überläufer bei Integer-Schlüssel.
*/

#include <stdlib.h>

#define m 7			/*Die Größe der Hashtabelle.*/

struct hash_node {
	struct hash_node *next;
	int key;
};

struct hash_node *t[m];	/*Die Hashtabelle.*/

static struct hash_node *father;
int hash_value;

struct hash_node *find(int s)
{
register struct hash_node *hn,*f;

	hash_value=s%m;
	hn=t[hash_value];
	f=NULL;
	while(hn) {
		if(hn->key==s) {
			father=f;
			return hn;
		}
		f=hn;
		hn=hn->next;
	}
	return NULL;
}

void insert(int s)
{
struct hash_node *hn;
int h;

	if(!(hn=malloc(sizeof(struct hash_node))))
		exit(10);
	hn->key=s;
	h=s%m;
	hn->next=t[h];
	t[h]=hn;
}

struct hash_node *remove(int s)
{
struct hash_node *hn;

	if((hn=find(s))!=NULL) {
		if(father) father->next=hn->next;
		else t[hash_value]=NULL;
	}
	return hn;
}
