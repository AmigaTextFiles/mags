#include <stdio.h>

int main(void)
{
  int pIntArray[5] = {0, 1, 2, 3, 4};
  char pStringArrayA[100] = {'H', 'e', 'l', 'l', 'o', '\0'};
	char pStringArrayB[100] = {84, 104, 101, 114, 101, 0};
	char pStringArrayC[100] = {"Today"};
	int i = 0;

	printf("%i.", 'a');

	printf("\npIntArray:\n");
	for (i = 0; i < 5; i++) printf("\n%i: %i.", i, pIntArray[i]);
	printf("\n\npStringArrayA: \"%s\"", pStringArrayA);
  printf("\npStringArrayB: \"%s\"", pStringArrayB);
	printf("\npStringArrayC: \"%s\"", pStringArrayC);

	return 0;
}
