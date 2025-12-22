/* prints "I am a fish" 10 times, using for loop */
#include <stdio.h>

void main(void)
{
  int i = 0;
  int stopval = 10;

  for (i = 0; i < stopval; i = i + 1) printf("I am a fish.\n");

  return;
}