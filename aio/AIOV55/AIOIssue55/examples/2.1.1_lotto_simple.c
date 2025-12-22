#include <stdio.h>

int main(void)
{
  long int secret[10];
  int i = 0;

  for (i = 0; i <= 9; i++)                          /* GOTCHA!!! Arrays _ALWAYS_ start at element 0. Always. */
  {
    printf("\nEnter secret number #%i: ", i);
    scanf("%i", &secret[i]);
  }
  printf("All done. The secret numbers were:\n");
  for (i = 0; i <= 9; i++) printf("\n#%i: %i", i, secret[i]);

  return 0;
}
