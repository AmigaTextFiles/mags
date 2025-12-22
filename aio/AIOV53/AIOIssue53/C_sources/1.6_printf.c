#include <stdio.h>
/* This prints an int as an int, then as a char, then prints a float with %g, then another float with %g, to demonstrate %g's automatic formatting nature. */
/* WARNING: This example requires floating point support. In vbcc, you will need to
  use an appropriate switch to do so. Eg: vc 1.7_scanf.c -o scanfexample -lmieee
*/

void main(void)
{
  int i = 66;
  float h = 6.626E-34;
  float pi = 3.14;
  printf("Variable i is: %i. This is the letter %c in the ASCII table. Planck's constant is roughly %g. The value of pi is roughly %g.\n", i, i, h, pi);

  return;
}