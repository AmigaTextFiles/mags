/*****************************************/
/*                                       */
/* 1. Calc element size                  */
/* 2. Calc array size                    */
/* 3. Alloc memory of size array_size    */
/* 4. Check if alloc was successful      */
/* 5. Enter & re-display numbers         */
/* 6. Free memory                        */
/* 7. Finish                             */
/*                                       */
/*****************************************/

#include <stdio.h>

int main(void)
{
  int i = 0;               /* <- This variable used for keeping track of which element in the array is being used */
  int returnval = 0;       /* <- main() returns returnval. Zero on success, -1 on memory alloc failure */
  size_t element_size = 0; /* <- Used to hold how many bytes each element is */
  size_t array_size = 0;   /* <- Used to hold how many bytes the array is */
  long int *pArray = NULL; /* <- Creates a variable pArray that holds a memory address for int */
  long int *pAlias = NULL; /* <- Also holds a memory address for int, just like pArray */

  element_size = sizeof(int);               /* <- Calc element size, in bytes, for ints */
  array_size = 10 * element_size;           /* <- Calc array size, in bytes, for 10 ints */
  pArray = (long int *) malloc(array_size); /* <- Alloc memory of size array_size, using a function called malloc(). */
                                            /* malloc() returns a memory address in the form of a void pointer. We   */
                                            /* cast that void address to a long int address, and assign it to pArray */
  if (pArray) /* <- Check if alloc was successful. non-zero evaluates to true. If pArray == NULL, it evaluates to false */
  {
    printf("\n10 elements of %i bytes each.", sizeof(long int) );
    printf("\nArray_size == %i bytes.", array_size);
    printf("\nAddress of allocated memory: %p.", pArray);
    printf("\nAddress of pArray, the variable holding \nthe address of the allocated memory: %p.", &pArray);
    pAlias = pArray;         /* <- Here, we make the contents of pAlias = pArray. So they both hold the */
                             /* same address and hence can both be used to access/manipulate the same   */
                             /* memory. Just because pArray was used to allocate the memory doesn't      */
                             /* somehow make it more "important" than pAlias; only the address counts.  */
    for (i = 0; i <= 9; i++)                    /* <- Our hand-made array is array_size big. We're stepping through it  */
    {                                           /* sizeof(long int) bytes at a time, even though i is being incremented */
      printf("\nEnter secret number %i: ", i);  /* by 1 each time. The compiler "knows" that each i is actually         */
      scanf("%i", pArray + i);                  /* sizeof(long int) bytes further along from the address pArray.        */
    }
    printf("All done. The secret numbers were (from address %p):\n", pArray);
    for (i = 0; i <= 9; i++)
    {
      printf("\nElement %i had address %p and it's contents was: %i.", i, pAlias, *pAlias); /* <- the asterix in this */
      pAlias++; /* context "dereferences", ie. evaluates to the *value* at the address it holds, rather than the      */
    }           /* *address* it holds.                                                                                  */
    free(pArray); /* <- Free memory. ALWAYS, always free memory when you're finished with it. */
    pArray = NULL;
    pAlias = NULL; /* <- NULL the pointers. Not really necessary in this example, but stray pointers are very bad.. */
  }
  else
  {
    printf("\nError: Memory allocation failed. Aborting.\n"); /* Print error message if pArray == NULL */
    returnval = -1; /* <- Return -1 if there was an error allocating memory */
  }

  return returnval; /* <- returnval should be zero if everything went ok */
}
