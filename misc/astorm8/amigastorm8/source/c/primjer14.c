#include <stdio.h>
struct data
{
        char ime[10];
        int starost;
};

int najmlaði(struct data *pod,int broj);

main()
{
        int adolescent;
        static struct data podaci[]=
        {
            {"Pero",34},
            {"Mika",24},
            {"Ðoko",34},
            {"Franjo",33},
            {"Sanjin",12}
        };

        adolescent=najmlaði (podaci,sizeof(podaci)/sizeof(struct data));

        printf("Najmlaða osoba:%s\n",podaci[adolescent].ime);
        printf("I ima samo %d godina.\n",podaci[adolescent].starost);

}

int najmlaði(struct data *pod, int broj)
{
        int min;
        broj--;
        for (min=broj;broj>=0;broj--)
        {
            if(pod[broj].starost < pod[min].starost)
              min=broj;
        }
        return min;
}