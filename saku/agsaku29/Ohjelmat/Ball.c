
/*
 Yritetty tehdä ohjelmaa jolla piirtyisi Boing Pallo 3-d:ä komeasti
 varjostettuna. Vaatii AGA:n

 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <intuition/intuition.h>
#include <intuition/screens.h>
#include <clib/exec_protos.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>
#include <graphics/rastport.h>

typedef struct Screen Screen;
typedef struct Window Window;
typedef struct IntuiMessage IntuiMessage;

Screen *Scr;
Window *Win;
struct TmpRas TmpRas;

struct NewScreen Ns = {
    0, 0, 640, -1, 8,
    -1, -1,
    LACE|HIRES,
    CUSTOMSCREEN,
    NULL,
    "Boing pallo"
};

struct NewWindow Nw = {
    0, 0, 0, 0,
    -1, -1,

    IDCMP_MOUSEBUTTONS|IDCMP_MOUSEMOVE|IDCMP_CLOSEWINDOW|IDCMP_NEWSIZE,

    WFLG_CLOSEGADGET|WFLG_DRAGBAR|WFLG_SIZEGADGET|
    WFLG_SIMPLE_REFRESH|WFLG_REPORTMOUSE|
    WFLG_ACTIVATE|WFLG_RMBTRAP|WFLG_NOCAREREFRESH,

    NULL, NULL, "Boing pallo",
    NULL,
    NULL,
    16, 32, -1, -1,
    CUSTOMSCREEN
};
struct piste{      /* tietuerakenne pisteille */
  int x;                /* alkuperäiset x,y.z */
  int y;
  int z;
  float xt;               /* kierretyt */
  float zt;
  float yt;
  int xscr,yscr;        /* screenin x ja y */
};
struct piste *pisteet;
int xmax=640,
    ymax=256,
    origx,
    origy,
    origz,
    x0,
    y0,
    kpl=64,
    kpl1;

float sini[3601],         /* taulukoidut sinit ja kosinit */
      cosi[3601];
int az,ax,ay;             /* kiertokulmat */
int ca;                   /* punaisten ja valkoisten värisävyjen määrä */
float r;
WORD koord[10]; /* Areamove, AreaDraw ja AreaEnd -funktioille */

UBYTE AreaBuffer[(5+1)*5];
struct AreaInfo AreaInfo;



/* Pyörittää pistettä p->(x,y,z) kulmien ax,ay ja az verran
   Tulos kenttiin p->(xt,yt,zt)                                 */

void Pyorita(struct piste *p)
{
    float txapu,tyapu,tzapu;
    txapu=(p->y*sini[az])+(p->x*cosi[az]);
    tyapu=(p->y*cosi[az])-(p->x*sini[az]);

    p->yt=(p->z*sini[ax])+(tyapu*cosi[ax]);
    tzapu=(p->z*cosi[ax])-(tyapu*sini[ax]);

    p->xt=(tzapu*sini[ay])+(txapu*cosi[ay]);
    p->zt=(tzapu*cosi[ay])-(txapu*sini[ay]);

}

/* Laskee pisteen p->(xt,yt,zt) projektion 2d tasossa screenillä */
void Projisoi(struct piste *p)
{
    float temp;
    if (p->zt==0) p->zt=1;
    temp=xmax/(xmax-(p->zt+origz));
    p->xscr=x0+(p->xt+origx)*temp;
    p->yscr=y0-((p->yt+origy)*temp);
 
}
void Piirra()
{
    int i,c,rkpl=4,kier=0,askel=0,pun;
    for (i=kpl+2; i<kpl1; i++)
     {
        if (pisteet[i].zt>0)
        {

         kier=i/(kpl+1);
         askel=i-(kier*(kpl+1));

         SHORT apu1=-(((askel-(askel>((kpl+1)/2)))/rkpl)%2);
         SHORT apu2=((((kier-1)/rkpl) %2)==1);

         pun = (apu1||apu2) && !(apu1 && apu2);
         pun=!(pun);

         if (pun) c=129; else c=255;

         /*printf("i=%d kier=%d askel=%d pun=%d color=%d\n",i,kier,askel,pun,c);*/


         float rr=-r;
         float etx=rr-pisteet[i].xt;
         float ety=-pisteet[i].yt;
         float etz=-pisteet[i].zt;

         float et2=((etx*etx)+(ety*ety)+(etz*etz));

         float alfa=facos((-et2+2*r*r)/(2*r*r));
         int tum=(ca-1)*(alfa/M_PI);

         /*printf("%d %lf %lf %lf %lf\n",tum,alfa/M_PI,etx,et2,alfa);*/

         SetAPen(Win->RPort,c-tum);
         koord[0]=pisteet[i].xscr; koord[1]=pisteet[i].yscr;
         koord[2]=pisteet[i-1].xscr; koord[3]=pisteet[i-1].yscr;
         koord[4]=pisteet[i-kpl-2].xscr; koord[5]=pisteet[i-kpl-2].yscr;
         koord[6]=pisteet[i-kpl-1].xscr; koord[7]=pisteet[i-kpl-1].yscr;
         koord[8]=pisteet[i].xscr; koord[9]=pisteet[i].yscr;


         AreaMove(Win->RPort,koord[0],koord[1]);
         AreaDraw(Win->RPort,koord[2],koord[3]);
         AreaDraw(Win->RPort,koord[4],koord[5]);
         AreaDraw(Win->RPort,koord[6],koord[7]);
         AreaDraw(Win->RPort,koord[8],koord[9]);
         AreaEnd(Win->RPort);
         }
     }
}


void myexit(void);

main(ac, av)
int ac;
char *av[];
{
    short notDone = 1;
    short down = 0;
    char pen = 1;

    atexit(myexit);
    int i;
  
   
    int a,b;
    float aske=3600/kpl;
    r=ymax/1.5;
    origx=0;
    origy=0.8*-r;
    origz=0;
    x0=xmax/2;
    y0=ymax/2;
    for (i=0; i<=3600; i++)
    {
        sini[i]=sin(2*M_PI*i/3600);
        cosi[i]=cos(2*M_PI*i/3600);
    }
    i=0;
    pisteet=(struct piste*) calloc(1,sizeof(struct piste));
    for (a=0; a<=1800; a=a+aske)
    {
        for (b=0; b<=3600; b=b+aske)
        {
                pisteet=(struct piste*) realloc(pisteet,(i+1)*sizeof(struct piste));
                pisteet[i].x=r*cosi[b]*sini[a];
                pisteet[i].y=r*sini[b];
                pisteet[i].z=r*cosi[b]*cosi[a];
                i++;
        }
    }
    az=450; ax=450; ay=450;


    kpl1=i;
    if (Scr = OpenScreen(&Ns)) {
        Nw.TopEdge= 6;
        Nw.Height = Scr->Height - Nw.TopEdge;
        Nw.Width  = Scr->Width;

        Nw.Screen = Scr;

        
        if (Win = OpenWindow(&Nw)) {


/****** Asetetaan värit 4-129 mustasta punaiseen ja 130 -255 mustasta valkoiseen *******/

            int c0=4;
            ca=(256-c0)/2;
            int i2=c0+ca-1,i1=c0;
            
            float k=255/ca;
            ULONG R;
            int ra;

            for (i=c0; i<=i2; i++) {   /* mustasta punaiseen */
                ra=(i-c0)*k;
                R=ra<<24;
                SetRGB32(&Scr->ViewPort,i,R,0,0);
            }
            i1=ca+c0;
            for (i=i1; i<=255; i++) {  /* mustasta valkoiseen */
                ra=(i-i1)*k;
                R=ra<<24;
                SetRGB32( &Scr->ViewPort,i,R,R,R);
            }   

/*********/
            InitArea(&AreaInfo,AreaBuffer,(4+1)*5);

            PLANEPTR Pointer;

            Pointer=AllocRaster(640,256);

            Win->RPort->AreaInfo=&AreaInfo;

            InitTmpRas(&TmpRas,Pointer,RASSIZE(640,256));
            Win->RPort->TmpRas=&TmpRas;

/**** Pyöritetään pisteitä ax,ay ja az astetta ja projisoidaan **************/

            for (i=0; i<kpl1; i++)
            {
                Pyorita(&pisteet[i]);
                Projisoi(&pisteet[i]);
            }

            Piirra();

            while (notDone) {   /* "Pääluuppi" jossa ei tehdä vielä mitään */
                IntuiMessage *imsg;

                WaitPort(Win->UserPort);
                while (imsg = (IntuiMessage *)GetMsg(Win->UserPort)) {
                    switch(imsg->Class) {
                    case IDCMP_CLOSEWINDOW:
                        notDone = 0;
                        break;
                    case IDCMP_MOUSEBUTTONS:
                        switch(imsg->Code) {
                        case SELECTDOWN:
                            down = 1;
                            break;
                        case SELECTUP:
                            down = 0;
                            break;
                        }
                        break;
                    case IDCMP_MOUSEMOVE:
                        if (down);
                        break;

                    case IDCMP_NEWSIZE:
                        Piirra();
                        break;
                    }
                    ReplyMsg(&imsg->ExecMessage);
                }
            }
        }
    }
    return(0);
}

void
myexit(void)
{
    if (Win) {
        CloseWindow(Win);
        Win = NULL;
    }
    if (Scr) {
        CloseScreen(Scr);
        Scr = NULL;
    }
    free(pisteet);
}

