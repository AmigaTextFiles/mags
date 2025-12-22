#include <stdio.h>
/* This asks for an int then a float value from user, then prints it back out again */
/* WARNING: This example requires floating point support. In vbcc, you will need to
  use an appropriate switch to do so. Eg: vc 1.7_scanf.c -o scanfexample -lmieee
*/
void main(void)
{
  int i_int = 0;
  float j_float = 0;

  printf("Please enter an integer value followed by a real value: ");
  scanf("%i %g", &i_int, &j_float);
  printf("\nVariable i_int is: %i. Variable j_float is: %g.\n", i_int, j_float);

  return;
}