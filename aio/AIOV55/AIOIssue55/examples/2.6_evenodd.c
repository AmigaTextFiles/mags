#include <stdio.h>

int main(void)
{
  int i = 0;
  int even_array[100];    /* create an array with the compiler */
  int * odd_array = NULL; /* int pointer for a "hand-made" array */
  int * odd_array_alias = NULL; /* will be modifying odd_array pointer, but still have to free() the original address. Remember original address with odd_array_alias */

  odd_array = (int *) calloc(100, sizeof(int) ); /* alloc mem for the "hand-made" pointer, 100 elements */
  odd_array_alias = odd_array;                   /* remember the original calloc()'d address with odd_array_alias */
  if (odd_array) /* error checking */
  {
    odd_array[0] = 1;  /* make first element the first odd number, 1 */
	even_array[0] = 2; /* make first element the first even number, 2 */
    for (i = 1; i <= 99; i++) /* loop 99 times (element 0 for both arrays are done), fill arrays */
    {
      odd_array[i] = odd_array[i - 1] + 2; /* fill odd array with odd numbers. This line shows a "hand-made" array can be used like a "compiler" one. */
      even_array[i] = even_array[i -1] + 2; /* fill even array with even numbers */
    }
	for (i = 0; i <= 99; i++) /* loop 100 times, display array contents */
    {
      printf("\n#:%i. Odd: %i. Even: %i.", i, *odd_array, even_array[i]);
      odd_array++; /* Move pointer to next element. Can't do this with even_array since it's a "fixed" pointer */
    }
	printf("\n\nFirst elements again: Odd: %i Even %i.\n", *odd_array_alias, *even_array); /* This line shows you can still dereference a "fixed" pointer in a "compiler" array */
    free(odd_array_alias); /* Can't use odd_array, since odd_array doesn't point to originally calloc'd address anymore. */
  } /* NB: In your own programming, try to use pointer aliases when you want to modifiable pointer, so you can use the same pointer used for calloc() with free() */
  else printf("\nMemory alloc failed.\n"); /* if odd_array failed on alloc */

  return 0;
}
