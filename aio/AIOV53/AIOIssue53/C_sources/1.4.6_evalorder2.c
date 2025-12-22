#include <stdio.h>

void main(void)
{
  int i, j, k;
  k = 3;
  i = k * 4;
  j = i + k; /* Now it's clear j == 15, i == 12, new variable k is == 3 */
  printf("Variable j is: %i.\nVariable i is: %i.\nVariable k is: %i.", j, i, k);
  return;
}