#include <stdio.h>
main()
{
  int a;
  int b;
  int max;
  printf("Unesi 2 broja:");
  scanf ("%d %d",&a,&b);

  max=a<b ? b : a;

  printf("Veæi je broj %d\n",max);

}
