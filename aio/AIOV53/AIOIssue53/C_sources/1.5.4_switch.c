#include <stdio.h>
/* should print out "Number 2!", "Still the number 2.", "Now it's 1." */

void main(void)
{
  int number = 2;

  switch(number)
  {
    case 1: 
      printf("Number 1!\n");
      printf("Number one!\n");
      break;
    case 2:
      {
        printf("Number 2!\n");
        printf("Still the number 2.\n");
        number = 1;
        printf("Now it's 1.\n");
      }
      break;
    default:
      printf("A number!\n");
      break;
  }
}