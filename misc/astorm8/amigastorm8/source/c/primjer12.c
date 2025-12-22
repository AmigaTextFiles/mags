#include <stdio.h>
void sort(int *niz); // Najava funkcije "sort" koja prima pointer na int
main()
{
        int a[10]={4,5,7,2,8,1,3,9,15,3}; // Pravi se niz i puni se s brojevima
        int i; // varijabla za potrebe for petlje
        printf("Niz je na poèetku izgledao ovako:\n");
        for (i=0;i<10;i++) // Ispis poèetnog stanja niza
        {
            printf ("%d ",a[i]);
        }
        sort(a); // Poziv funkcije "sort". Moglo je i: sort(&a[0]);
        printf("\nA sada izgleda ovako:\n");
        for (i=0;i<10;i++) // Potpuno isti ispis novonastalog stanja
        {
            printf ("%d ",a[i]);
        }
        printf ("\n");
}
void sort(int *niz)
{
        int i,j,tmp; // "i" i "j" su indeksne varijable, a "tmp" slu¾i za privremeni
        for (i=0;i<9;i++) // smje¹taj vrijednosti prilikom zamjene sadr¾aja
        {
            for(j=i+1;j<10;j++) // Usporeðuje se svaki sa svakim elementom
            {
                if(niz[i]>niz[j]) // Ako je veci ispred manjeg
                {
                    tmp=niz[i]; // zamjenjuju mjesta
                    niz[i]=niz[j];
                    niz[j]=tmp;
                }
            }
        }
}