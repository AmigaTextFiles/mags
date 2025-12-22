#include <stdio.h>

/* Should print message, then "value of test: 13." - because there's 12 printed characters + new line character. */

void main(void)
{
  int test = 0;

  test = printf("Hello world!\n");
  printf("value of test: %i.\n", test);
  return;
}