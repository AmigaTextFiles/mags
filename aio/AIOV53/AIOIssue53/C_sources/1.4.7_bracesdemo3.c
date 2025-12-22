#include <stdio.h>

void main(void)
{
  int i;  /* create a variable called i; see section "declaring variables" */

  i = 5;
  if (i == 5)
  {
    printf("i equals 5.\n");
    printf("i still equals 5.\n");
  }
  else
  {
    printf("i does not equal 5.\n");
    i = 5;
    printf("now i equals 5.\n");
  }

  i = 3;
  printf("Modified i to become 3.\n");
  if (i == 5)
  {
    printf("i equals 5.\n");
    printf("i still equals 5.\n");
  }
  else
  {
    printf("i does not equal 5.\n");
    i = 5;
    printf("now i equals 5.\n");
  }
  printf("Value of i: %i.\n", i);
  return;
}