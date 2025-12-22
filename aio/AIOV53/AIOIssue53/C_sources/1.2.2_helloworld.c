#include <stdio.h>

int rainmessage(void)
{
  printf("It's raining today.\n");
  return 5;
}

void main(void)
{
  printf("Hello world!\n");
  printf("rainmessage() returned: %i.\n", rainmessage());
  return;
}