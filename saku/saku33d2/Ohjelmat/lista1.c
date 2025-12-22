#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
void main()
{   struct Task *task = FindTask(NULL);   //CNTRL-C keskeytys!!
    long r=1, s=1,ss,sr,a,b,c;     //rivi‰ ja saraketta juoksutetaan vinottain
    short dr=-1, ds=1;
    long i=0,syti=0,k=10,j=2,jk=1;
    double max=0,suhde;
    printf("Keskeytys CNTRL-C:ll‰\n");
    do {
        i++;         // i:ss‰ kaikkien lukum‰‰r‰
        a=r;b=s;     //lasketaan Eukliden algoritmill‰ suurin yhteinen tekij‰
        if (a<b) {
            a=s;
            b=r;
        }
        c=1;
        while(c!=0) {    //a:han tulee a:n ja b:n suurin yhteinen
                         //tekij‰ joka voidaan sievent‰‰ a/b:st‰
            c=a%b;
            a=b;
            b=c;
        }
        syti=syti+(a!=1);

        ss=s/a;
        sr=r/a;
        if (sr/ss>max) max=sr/ss;

        if (i==k || i<10) {
            suhde=max/(i-syti);
            printf("%7d %7d %5d %lf\n",i,i-syti,(int)max,suhde);
            if (i>=10) {
                k=j*pow(10,jk);
                j=j+1;
                if (j==5) {
                    j=2;
                    k=pow(10,++jk);
                }
            }
        }
        //printf("%d %d %d\n",k,j,jk);
        r=r+dr;
        s=s+ds;
        if (r<1) {r=1; dr=1; ds=-1;}
        if (s<1) {s=1; ds=1; dr=-1;}
    } while((task->tc_SigRecvd & SIGBREAKF_CTRL_C) == 0);
}
