
/* Tämä näppärä ohejlma tuli tehtyä kun luulintarvitsevani
alkulukuja murtolukujen sievennykseen, mutta Euklideen
algoritmillä löytyy syt eli suurin yhteinen tekijä näppärämmin,
ilman että tarvitsee jakaa lukuja kaikkiin tekijöihin...*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
int i,i2,j=2,
    lkm=200,    //1217
    luku=3;
int    *alkuluvut;
float neliojuuri;
main(ac, av)
int ac;
char *av[];
{
     if (ac == 1) {
        puts("Alkuluvut.exe <lkm> esim. Alkuluvut.exe 50");
        exit(1);
    }

    lkm=atoi(av[1]);

    unsigned koko = sizeof(int);
    alkuluvut=(int *) calloc(lkm+1,koko);
    if (alkuluvut== NULL) {
        puts("Taulukon varaaminen ei onnistunut");
        exit(1);
    }
    alkuluvut[0]=1;
    alkuluvut[1]=2;
    do
    {
        neliojuuri=fsqrt(luku);  /* luvun suurin tekijä<luvun neliöjuuri */
        i2=1;
        do
        {
            if ((luku%alkuluvut[i2])==0) break;
            if ((alkuluvut[i2]>neliojuuri) || (i2>=j))
            {
                alkuluvut[j++]=luku;
                printf("   %d. alkuluku = %d\n",j,luku);
                break;
            }
            i2++;
        } while (1);
        luku=luku+2;
    } while (j<lkm);
    free(alkuluvut);
}
