#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
void main()
{   struct Task *task = FindTask(NULL);  //CNTRL-C:ll‰ pois!
    long r=1, s=1,ss,sr;     //rivi‰ ja saraketta juoksutetaan vinottain
    long otantalkm=1000,dsyti,otantalaskuri=0;
    short dr=-1, ds=1;
    long a,b,c,i=0,k=10,syti=0;
    double suhde,dsuhde;
    printf("Ohjelma Keskeytyy CNTRL-C:ll‰.\n");
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
        
        if (i==k || i<20 || i==2000000000) {
            if (i==k) k=10*k;
            ss=s/a;
            sr=r/a;
            suhde=(double)syti/i;
            printf("\n%10d %8d %6d/%d %6d/%d %lf",i,syti,r,s,sr,ss,suhde);
            if (i>=1000) {
            otantalaskuri=otantalkm;
            dsyti=0;
            }
        }
        if (otantalaskuri>0) {
            dsyti=dsyti+(a!=1);
            otantalaskuri--;
            
            if (otantalaskuri==0) {
                dsuhde=(double)dsyti/otantalkm;
                printf(" %lf %d:n joukossa",dsuhde,otantalkm);
            }
        }
        r=r+dr;
        s=s+ds;
        if (r<1) {r=1; dr=1; ds=-1;}
        if (s<1) {s=1; ds=1; dr=-1;}
     
    } while((task->tc_SigRecvd & SIGBREAKF_CTRL_C) == 0);
    if(r!=1 && s!=1) {
        b=(s-ds)/a;
        a=(r-dr)/a;
        suhde=(float)syti/i;
        printf("%10d %8d %6d/%d %6d/%d %lf\n",i,syti,(r-dr),(s-ds),ss,sr,suhde);
    } else printf("%10d %8d (%6d/%d) %6d/%d %lf\n",i,syti,r,s,sr,ss,suhde);
}
