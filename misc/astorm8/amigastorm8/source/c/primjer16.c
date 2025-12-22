#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct list {
  char *s;
  struct list *next;
};
struct list * dodaj(struct list *,char *);
void pisi(struct list *);
void brisi(struct list *);

main()
{
  struct list *prva=NULL;
  struct list *zadnja=NULL; 
  prva=zadnja=dodaj (prva,"Prva struktura liste.");
   
  zadnja=dodaj(zadnja,"Druga struktura liste.");
  zadnja=dodaj(zadnja,"Treæa struktura liste.");

  pisi(prva);
  brisi(prva);

}

struct list * dodaj(struct list *list,char *string)
{
  struct list *tmp;
  tmp=malloc(sizeof(struct list));
  tmp->s=malloc(strlen(string)+1);
  strcpy(tmp->s,string);
  tmp->next=NULL;

  if (list)
  {
    list->next=tmp;
  }
  return tmp;
  
}
void brisi(struct list *list)
{
  struct list *tmp;

  while(list)
  {
    tmp=list->next;
    free(list->s);
    free(list);
    list=tmp;  
  }
}

void pisi(struct list *list)
{
  struct list *tmp;
  
  while(list)
  {
    tmp=list->next;
    printf("%s\n",list->s);
    list=tmp;  
  }
}
