#include <stdio.h>

void main(void)
{
  int i = 3;
  char c = 0;

  c = (char) i;  /* cast the int to a char */
  printf("Value of c: %i.\n", c);
  return;
}