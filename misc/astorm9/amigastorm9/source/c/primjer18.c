#include <stdio.h>
main (int argc, char *argv[]) // Ovo vi¹e ne treba obja¹njavati.
{
     FILE *in; // 2 pointera na varijablu tipa FILE
     FILE *out; // Jer treba otvoriti 2 fajla
     char c; // Pomoæna varijabla za privremeni smje¹taj podataka
     if (argc!=3) // Da li je pogre¹no pozvan program?
     {
          printf("Usage: convert pcfile amigafile\n");
          return(0); // Ako jeste izaði iz programa.
     }
     in=fopen(argv[1],"r"); // Otvaramo fajl za èitanje - "r"
     if (in==NULL) // Jel' fajl pronadjem ?
     {
          printf("Can't open file %s.\n",argv[1]);
          return(1); // Ako nije, opet je gre¹ka posrijedi
     }
          out=fopen(argv[2],"w"); // otvori fajl za snimanje - "w"
     if(out==NULL) // Jel' to uspje¹no obavljeno?
     {
     fclose(in); // Ako nije potrebno je zatvoriti predhodno otvoreni,
     printf("Can't save file.\n"); // ispisati prigodnu poruku
     return(2); // i izaæi iz programa
     }
     printf("Converting %s to %s.\n",argv[1],argv[2]); // Najzad je sve OK!!

     while ((c=getc(in))!=EOF) // Char-ovi se uzimaju dok se ne naiðe na EOF
     {
          if (c!=13) // Ako c nije 13 (CR)
               putc(c,out); // treba ga snimiti
     }
     fclose(in); // Sve ¹to je otvoreno
     fclose(out); // mora se uvijek i zatvoriti.
     printf("Finished!\n"); // Gotovo (napokon)
}
