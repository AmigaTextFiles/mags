#include <stdio.h>

void main(void)
{
  int parent_i = 1;
  
  printf("\nFrom main block: parent_i is %i.", parent_i);
  {
    int child1_i = 2;

    printf("\nFrom 1st nested block: Value of child1_i: %i", child1_i);
    {
      printf("\nFrom 2nd nested block: Value of child1_i: %i", child1_i);
    }
    printf("\nFrom 1st nested block: Value of parent_i: %i", child1_i);
    parent_i = 4;
    printf("\nFrom 1st nested block: Modified parent_i. Value of parent_i: %i", child1_i);

  }
  printf("\nFrom main block: child1_i is %i.", child1_i);
  printf("\nFrom main block: parent_i is %i.", parent_i);
  return;
}