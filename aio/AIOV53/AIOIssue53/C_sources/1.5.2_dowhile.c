/* prints "I am a fish" 10 times, using while loop */
#include <stdio.h>

void main(void)
{
  int i = 0;
  int stopval = 10;

  do
  {
    printf("I am a fish.\n");
    i = i + 1;
  }
  while (i < 10);
  return;
}