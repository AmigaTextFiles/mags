#include <stdio.h>
main (int argc, char *argv[])
{
     int i;
     printf("Ispisano je %d rijeèi i to su:\n",argc); // Koliko je argc?
     for (i=0;i<argc;i++) // Treba ispisati sve èlanove niza
     {
          printf("%s",argv[i]); // Ispi¹i trenutni string
          if(i<argc-1) // Ako nije zadnji
               printf(" "); // Odvoji ga od slijedeæeg razmakom
          else // A ako jeste
               printf("\n"); // Prijeði u novi red
     }
}