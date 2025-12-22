#include <stdio.h>
void swap(int *a,int *b);  
main()
{
  int a=10,b=5;
  swap(&a,&b);
  printf("Sada je: a=%d, b=%d\n",a,b);
}
void swap (int *a,int *b)
{
  int t;
  t=*a;
  *a=*b;
  *b=t;
}