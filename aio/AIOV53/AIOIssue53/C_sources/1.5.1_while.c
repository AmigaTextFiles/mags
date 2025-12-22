/* prints "I am a fish" 10 times, using while loop */
#include <stdio.h>

void main(void)
{
  int i = 0;
  int stopval = 10;

  while (i < stopval)
  {
    printf("I am a fish.\n");
    i = i + 1;
  }
  return;
}