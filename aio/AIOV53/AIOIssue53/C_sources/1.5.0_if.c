/* should print "i equals 3." */
#include <stdio.h>

void main(void)
{
  int i = 3;

  if (i == 3) printf("i equals 3.\n");
  else
  {
    printf("i doesn't equal 3.\n");
    i = 3;
    printf("Now it does.\n");
  }
  return;
}