/*	Implementation eines LIFO-Stacks*/

#include <stdlib.h>
#include "list_2-1.h"

/*	Konstruktor - jeder Stack muß damit initialisiert werden.
	s ... Größe der auf dem Stack gespeicherten Elemente
	n ... Anzahl der Elemente pro Knoten
*/

lifo(register struct lifo *this,size_t s,int n)
{
	this->capacity=s*n;
	this->first=NULL;
	this->type_size=s;
	return 0;
}

void clear(register struct lifo *this)
{
register struct	lifo_node *ln;

	while((ln=this->first)!=NULL) {
		this->first=this->first->next;
		free(ln);
	}
}

/*	Destruktor - jeder Stack muß damit deaktiviert werden.*/

lifo_(struct lifo *this)
{
	clear(this);
	return 0;
}

/*	push legt das angeg. Objekt auf den Stapel.*/

void push(register struct lifo *this,void *ptr)
{
register struct	lifo_node *ln;

	ln=this->first;
	if(!ln || !ln->bytes_left) {
		if(!(this->first=malloc(sizeof(struct lifo_node)+this->capacity-2)))
			exit(10);
		this->first->bytes_left=this->capacity;
		this->first->next=ln;
		ln=this->first;
	}
	ln->bytes_left-=this->type_size;
	if(this->type_size==1) ln->data[ln->bytes_left]=*(const char *)ptr;
	else movmem(ptr,&ln->data[ln->bytes_left],this->type_size);
}

/*	pop holt das oberste Element nach ptr.*/

int pop(register struct lifo *this,void *ptr)
{
struct	lifo_node *ln;

	ln=this->first;
	if(ln) {
		if(this->type_size==1) *(char *)ptr=ln->data[ln->bytes_left];
		else movmem(&ln->data[ln->bytes_left],ptr,this->type_size);
		if((ln->bytes_left+=this->type_size)==this->capacity) {
			this->first=this->first->next;
			free(ln);
		}
		return 1;
	}
	return 0;
}

/*	top gibt einen Pointer auf das oberste Element zurück.
	Dieser ist nur bis zur nächsten pop-Operation gültig.
*/

void *top(register struct lifo *this)
{
register struct	lifo_node *ln;

	ln=this->first;
	if(ln) return &ln->data[ln->bytes_left];
	return NULL;
}
