#include <stdio.h> 
#include <string.h> 
 
main() 
{ 
        char a[]="Amiga"; 
        char b[]=" rules!!"; 
        char c[20];   // 20 znakova æe biti dovoljno.  
        strcpy (c,a);    // Prvo kopiramo niz a u niz c. 
        strcat (c,b);    // A zatim nizu c nadovezujemo niz b. 
 
        /*  Postoji i varijante "strncpy" i "strncat" koje koriste najvi¹e n znakova pa je tako moguæe izbjeæi prekoraèenje */ 
 
        printf("%s\n",c);  // %s po¹to se radi o stringu. 
        printf("String je dug %d znaka.\n",strlen(c)); 
 
}
