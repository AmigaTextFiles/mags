#include <stdio.h>

void main(void)
{
  int j, i;
  j = (i = 3) + (i = i * 4); /* Does j == 3 or does j == 15? i == 3 or i ==12? */
  printf("Variable j is: %i.\nVariable i is: %i.\n", j, i);
  return;
}