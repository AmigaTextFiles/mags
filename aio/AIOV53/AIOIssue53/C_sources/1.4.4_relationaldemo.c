#include <stdio.h>

void main(void)
{
  int i = 0;
  int j = 10;
  int test = 4;

  if ( (test >= i) && (test <= j) ) printf("%i is between %i and %i.\n", test, i, j);
  if !( (test >= i) && (test <= j) ) printf("%i is NOT between %i and %i.\n", test, i, j);

  test = 34;

  if ( (test >= i) && (test <= j) ) printf("%i is between %i and %i.\n", test, i, j);
  if !( (test >= i) && (test <= j) ) printf("%i is NOT between %i and %i.\n", test, i, j);
  return;
}