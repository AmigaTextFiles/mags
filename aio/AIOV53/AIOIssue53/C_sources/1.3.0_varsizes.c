#include <stdio.h> /* must include stdio.h for sizeof() */
/* you may need to include stddef.h or similar to use size_t type */
/* if this fails, make i_size a normal int */

void main(void)
{
  int i = 0;
  size_t i_size = 0;
  
  i_size = sizeof(i);
  printf("i_size takes up %i bytes in memory.\n", i_size); /* printf() is covered towards the end of this tutorial. For now, just accept that this line will print the value of i_size as an integer (hence the 'i' in '%i'). */

  return;
}