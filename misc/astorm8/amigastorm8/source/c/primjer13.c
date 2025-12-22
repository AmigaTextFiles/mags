#include <stdio.h>
struct radnik
{
        char ime[15];
        char prezime[20];
        int roðen;
        char adresa[30];
        float plaæa;
};

main()
{
        struct radnik prvi={"Pero","Periæ",1965,"Ujedinjenih naroda 99",1046.376};

        printf("Radnik:%s %s\n", prvi.ime, prvi.prezime);
        printf("Roðen:%d godine\n", prvi.roðen);
        printf("Adresa:%s\n", prvi.adresa);
        printf("S prosjeènom plaæom %f DM\n", prvi.plaæa);

}