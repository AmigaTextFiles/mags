/*	Implementation eines LIFO-Stacks*/

#include <stddef.h>

struct lifo_node {
	struct	lifo_node *next;
	int	bytes_left;
	char	data[2];
};

struct lifo {
	struct	lifo_node *first;
	size_t	type_size;
	size_t	capacity;
};

#define isempty(lifo) ((lifo)->first==NULL)
#define ontop(lifo) ((void*)((lifo)->first->data+(lifo)->first->bytes_left))

int lifo(register struct lifo *,size_t,int),lifo_(struct lifo *);
void clear(register struct lifo *);
void push(register struct lifo *,void *ptr);
int pop(register struct lifo *,void *ptr);
void *top(register struct lifo *);
