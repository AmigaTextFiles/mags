#include <stdio.h>
#include <string.h>

int main(void)
{
  char * pString[100];
  char * pAlias = pString;

  memset(pString, 0, 100);
  memcpy(pString, "The quick, brown-looking fox-like creature.\0", 44); /* Note the literal string is 45 chars, but the "\0" sequence is one char: NULL */
  printf("\npString: \"%s\"", pString);
  memcpy(pString, "The quick brown fox.\0", 21); /* 20 chars of text, + 1 for the NULL ("\0") sequence */
  printf("\npString: \"%s\"", pString);
  pAlias += 21;
  printf("\npString + 21 (pAlias):        \"%s\"", pAlias); /* printf() starts printing from 21 chars past pString (pAlias) */

  return 0;
}
