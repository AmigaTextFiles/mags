#include <stdio.h>

int main(void)
{
  int name_len = 0;           /* Holds the length of the name */
  int i = 0;
  char pString[100];          /* Create a "string"; an array of 100 char */
  char *pAlias = pString;     /* Create an alias for pString */

  memset(pString, 0, 100); /* init the first 100 chars of the string to all zeroes */
  printf("\nEnter your first name (max 100 chars): ");
  scanf("%s", pString); /* scanf will only accept one word; any characters after the first space, tab etc will be ignored */
  while ( (*pAlias != 0) && (name_len < 100) ) /* Loop is designed to step through the string until the end of the name */
  {                                            /* (char @ pAlias == NULL), or the string, is reached */
    name_len++;
    pAlias++;
  }
  /* Right now, pAlias is pointing just after the last character in the string. */
  printf("\nName is %i characters long. Name spelt backwards: ", name_len);
  while (pAlias >= pString) /* Loop until pAlias points to pString again */
  {     /* The job for this loop is to step through the string backwards, printing each character as it goes. */
    printf("%c", *pAlias); /* "%c" displays whatever the parameter evaluates to as an ASCII character, hence dereference */
    pAlias--;              /* Move back one character. */
  }

  return 0;
}
