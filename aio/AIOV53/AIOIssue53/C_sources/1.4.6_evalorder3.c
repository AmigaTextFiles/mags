#include <stdio.h>

void main(void)
{
  int i, j, k;
  j = (k = 3, i = k * 4, i + k); /* k is set to 3, i = k * 4 evaluates to 12, 3 + 12 evaluates to 15 and is assigned to j. i ends up equal to 12. */
  printf("Variable j is: %i.\nVariable i is: %i.\nVariable k is: %i.", j, i, k);
  return;
}