#include <stdio.h>

int main(void)
{
  int * pointer1 = NULL;
  int * pointer2 = NULL;

  pointer1 = (int *) malloc(100 * sizeof(int)); /* allocate 100 * sizeof(int) bytes */
  pointer2 = (int *) calloc(100, sizeof(int));  /* allocate 100 ints */
  if (pointer1) free(pointer1);    /* if pointer1 is non-zero, free it again */
  else printf("Couldn't allocate memory for pointer1.\n"); /* otherwise an error occurred */
  if (pointer2) free(pointer2);    /* if pointer2 is non-zero, free it again */
  else printf("Couldn't allocate memory for pointer2.\n"); /* otherwise an error occurred */

  return 0;
}
