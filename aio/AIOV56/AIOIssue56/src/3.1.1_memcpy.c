#include <stdio.h>
#include <string.h>

int main(void)
{
  char * pString[100];

	memset(pString, 0, 100);
	memcpy(pString, "The quick, brown-looking fox-like creature.", 43);
	printf("\npString: \"%s\"", pString);
	memcpy(pString, "The quick brown fox.", 20);
	printf("\npString: \"%s\"", pString);

	return 0;
}
