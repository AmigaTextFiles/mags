#include <stdio.h>

int main(void)
{
  int i = 0;      /* A normal int. */
  int *pInt = &i; /* An int pointer, initialised to the address of i. pInt is now an "alias" for i. */
  int **ppInt = &pInt; /* This might get confusing. You can ignore it for now if you want; it's a pointer to another pointer. This other pointer is an int pointer, which points to the data i holds :-) */

  i = 2; /* Make i equal two. Nothing new here. */
  printf("\n&i == %p. pInt == %p. &pInt == %p. i == %i. *pInt == %i.", &i, pInt, &pInt, i, *pInt);
  *pInt = 5; /* Dereferenced; we'e not changing the pointer itself, but the data the pointer points to */
  printf("\n&i == %p. pInt == %p. &pInt == %p. i == %i. *pInt == %i.", &i, pInt, &pInt, i, *pInt);
  **ppInt = 97696; /* Double dereferenced; we're changing the data at the address of the address held in ppInt */
  printf("\n&i == %p. pInt == %p. &pInt == %p. i == %i. *pInt == %i.", &i, pInt, &pInt, i, *pInt);

  return 0;
}
