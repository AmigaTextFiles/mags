/* Double Hashing, ein offenes Hashverfahren */

#include <stdlib.h>
#include <string.h>

struct double_hash {
	int m;
	int unused;
	long (*getkey)(const void *);
	void *(*t)[];
};

#define frei(x) ((x)==NULL)
#define entfernt(x) ((x)==this->t)
#define belegt(x) (!frei(x) && !entfernt(x))

	/*Konstruktor*/

c_double_hash(struct double_hash *this,int size,long (*f)(const void *))
{
	this->unused=this->m=size;
	this->getkey=f;
	this->t=malloc(sizeof(void*)*size);
	if(this->t==NULL) exit(10);
	memset((void*)this->t,0,sizeof(void*)*size);
	return 0;
}

	/*Destruktor*/

d_double_hash(struct double_hash *this)
{
	free(this->t);
	return 0;
}

	/*Suchfunktion*/

void *hash_find(register struct double_hash *this,void *s)
{
long k,h1,h2;
void *vp;

	h1=k=this->getkey(s);
	h2=1+h1%(this->m-2);
	while(vp=(*this->t)[h1%this->m],!frei(vp)) {
		if(!entfernt(vp) && k==this->getkey(vp))
			return vp;
		h1-=h2;
	}
	return NULL;
}

	/*Einfügeoperation*/

int hash_insert(register struct double_hash *this,void *s)
{
long h1,h2;
void *vp;

	if(!this->unused) return 0;
	h1=this->getkey(s);
	h2=1+h1%(this->m-2);
	while(vp=(*this->t)[h1%this->m],belegt(vp))
		h1-=h2;
	(*this->t)[h1%this->m]=s;
	this->unused--;
	return 1;
}

	/*zum Entfernen*/

void *hash_remove(struct double_hash *this,void *s)
{
long k,h1,h2;
void *vp;

	h1=k=this->getkey(s);
	h2=1+h1%(this->m-2);
	while(vp=(*this->t)[h1%this->m],belegt(vp)) {
		if(!entfernt(vp) && k==this->getkey(vp)) {
			(*this->t)[h1%this->m]=this->t;
			this->unused++;
			return vp;
		}
		h1-=h2;
	}
	return NULL;
}


	/*Zum Austesten*/

#include <stdio.h>

struct double_hash table;

long ptr2key(const void *ptr)
{
	return *(const int *)ptr;
}

void show(struct double_hash *this)
{
int i;
void *vp;

	printf("\f");
	for(i=0;i<this->m;i++) printf("\t%3d",i);
	putchar('\n');
	for(i=0;i<this->m;i++) {
		vp=(*this->t)[i];
		if(frei(vp)) printf("\t___");
		else if(entfernt(vp)) printf("\txxx");
		else printf("\t%3ld",this->getkey(vp));
	}
	putchar('\n');
}

void main(int argc,char **argv)
{
int i,k[]={12,5,19,26,33,61,89};

	c_double_hash(&table,7,ptr2key);

	for(i=0;i<sizeof(k)/sizeof(int);i++) {
		hash_insert(&table,&k[i]);
		show(&table);
		printf("Nach dem Einfügen von %d.\n",k[i]);
		printf("%d%%%d=%d\n",k[i],table.m,k[i]%table.m);
		printf("1+%d%%(%d-2)=%d\n",k[i],table.m,1+k[i]%(table.m-2));
		(void)getchar();
	}
	d_double_hash(&table);
}
