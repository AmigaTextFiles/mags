

/*
Suhtiskuvaajat. Kääntyy DICEllä ainakin seuraavalla käskylitanialla:

dcc T:TEST.C -no-env -3.1 -fpp -d1 -lm -030 -E ram:er -R -// -f



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
#include <graphics/view.h>
typedef struct Screen Screen;
typedef struct Window Window;
typedef struct IntuiMessage IntuiMessage;
Screen *Scr;
Window *Win;

#define MAXX 640
#define MAXY 256
#define depth 4
#define scrid  0x8000 //0x89024

#define RP   Win->RPort
int cols;

struct TmpRas TmpRas;
PLANEPTR Pointer;
#define RASX 30

double koord[10]; 
UBYTE AreaBuffer[(5+1)*5];
struct AreaInfo AreaInfo;

struct Library *DiskfontBase;
struct TextAttr myfontattr=           /* vaihda toinen fontti jos tätä ei löydy*/
{
  "qc.font", /* Name of the font.  */
  6,          /* Height (in pixels) */
  FS_NORMAL,   /* Style              */
  FPF_DISKFONT /* Exist on Disk.     */
};

            struct TextFont *myfont;

struct NewScreen Ns = {
  0,            /* LeftEdge */
  0,            /* TopEdge */
  MAXX,         /* Width   */
  MAXY,         /* Height  */
  depth,        /* Depth   */
  0,            /* DetailPen */
  1,            /* BlockPen  */
  0x8000,      /* ViewModes */
  CUSTOMSCREEN, /* Type */
  NULL,         /* Font */
  "Suhtistaidetta",  /* Title   Peittyy*/
  NULL,         /* Gadget */
  NULL          /* BitMap */
};
struct NewWindow Nw =  {
  0,            /* LeftEdge */
  0,            /* TopEdge  */
  MAXX,         /* Width  */
  MAXY,         /* Height */
  0,            /* DetailPen */
  1,            /* BlockPen   */
  IDCMP_CLOSEWINDOW, /* IDCMPFlags */
  WFLG_CLOSEGADGET|  /* Flags*/
  WFLG_ACTIVATE|
  WFLG_BORDERLESS|
  WFLG_DRAGBAR,
  NULL,         /* FirstGadget  Ei käyttöä. */
  NULL,         /* CheckMark    Ei customia */
  "Lausekkeen a/Sqrt(1-v²)", /* Title Ei näy */
  NULL,         /* Screen       Asetetaan screenin avauksen jälkeen*/
  NULL,         /* BitMap       Ei custom-bitmappia */
  0,            /* MinWidth     Ei käyttöä koska ei SIZEGADGETtiä*/
  0,            /* MinHeight    */
  0,            /* MaxWidth     */
  0,            /* MaxHeight    */
  CUSTOMSCREEN  /* Type*/
};

#define vaskel 5      /* värit joiden välille liukumat */
int v[vaskel][3]={{200,200,0},{228,72,128},{20,0,255},{200,120,120},{200,200,0}};


                   /* Liukuma värirekisteristä i1(R1,G1,B1) i2:een(R2,G2,B2) */
void liukuma(int R1, int G1,int B1,int R2,int G2,int B2,int i1,int i2)
{   int i,R,G,B;
    double kr=(R2-R1)/(i2-i1),  /* "kulmakertoimet" kasvulle */
           kg=(G2-G1)/(i2-i1),
           kb=(B2-B1)/(i2-i1);
    for (i=i1; i<=i2; i++)  {
        if (i<cols)  {          /* kutsussa i2 voi olla cols vaikka 0 <= i <= cols-1 */
            R=R1+kr*(i-i1);     /* ehto jotta voidaan saadaan liukuma, jossa vikaa  */
            G=G1+kg*(i-i1);     /* väriä seuraisi eka, kutsumalla arvolla i2=cols   */
            B=B1+kb*(i-i1);
            SetRGB32(&Scr->ViewPort,i,R<<24,G<<24,B<<24);
        }
    }
}



void boxi(int x1,int y1,int x2,int y2, vari)
{   SetAPen(RP,vari);
    Move(RP,x1,y1);
    Draw(RP,x2,y1);
    Draw(RP,x2,y2);
    Draw(RP,x1,y2);
    Draw(RP,x1,y1);
}



double massaX(double lepomassa,double nopeus)
{   double y;
    y=lepomassa/sqrt(1-(nopeus/(MAXX-1))*(nopeus/(MAXX-1)));
    if (y>MAXY) y=MAXY;
    return(y);
}



void tulosta(double x,double y,char formatbuf[256])   /* huolehtii lukujen tulostuksesta */
{ STATIC int RIVI=13, SARA=6;
                                    /* Text-funktiolla voi tulostaa vain  */
  char buf1[256];                   /* stringejä. Koska en löytänyt       */
                                    /* float to string funktiota, tulostan */
                                    /* floatin puskuriin ja luen sieltä stringin*/


    Move(RP,SARA,RIVI);

    if(RIVI==13) {
        Text(RP,"nopeus%    massa",16);
        RIVI=20;

    }
    Move(RP,SARA,RIVI);
    sprintf(buf1,formatbuf,x*100,y);

    Text(RP,buf1,strlen(buf1)-1);

    RIVI=RIVI+7;
    if (RIVI>MAXY-20) {RIVI=13; SARA=SARA+150;}
}

void myexit(void);

main(ac, av)
int ac;
char *av[];
{
    short notDone = 1;
    atexit(myexit);
    if (Scr = OpenScreen(&Ns)) {
        Nw.Screen = Scr;
        cols=fpow(2.0,depth);
        if (Win = OpenWindow(&Nw)) {
            Pointer=AllocRaster(RASX,MAXY);
            InitTmpRas(&TmpRas,Pointer,RASSIZE(RASX,MAXY));
            RP->TmpRas=&TmpRas;

            InitArea(&AreaInfo,AreaBuffer,(4+1)*5);
            RP->AreaInfo=&AreaInfo;

            int i;
            for (i=0;i<vaskel-1;i++) {

            liukuma(v[i][0],v[i][1],v[i][2],v[i+1][0],v[i+1][1],v[i+1][2],
                        i*(cols/(vaskel-1))+1,(i+1)*(cols/(vaskel-1))+1);
   
            }

            SetRGB32(&Scr->ViewPort,0,0<<24,0<<24,0<<24);
            double x,m0,med=0;

            SetAPen(RP,0);                  /* ruudun tyhjennys */
            RectFill(RP,0,0,MAXX-1 ,MAXY-1);


            int vari=0.6*cols;
            double mi,       /* lepomassa */
                   mimax=7*cols,      /* värit läpi seitsemän kertaa */
                   dm=(MAXY-1)/mimax, /* lepomassan kasvu seuraavalle käyrälle*/
                   edx,dx=1; //dx max 7.5 (RASX=30...ja 4*7.5=30...)
          //  goto APU;
            for (mi=0; mi<=mimax+2; mi++) {   /* suhtis kuvaajat lepomassa looppi*/
                m0=(mi-2)*dm;
                if (mi==0) m0=0;            /* aluksi vähän tiheämpää kuin dm */
                if (mi==1) m0=0.1*dm;
                if (mi==2) m0=0.5*dm;

                SetAPen(RP,vari%(cols-1)+1);
                vari++;
                x=0;edx=0;
                while (x<MAXX)  {                /* lasketaan neljä koordinaattia joiden
                                                    määräämä alue väritetään Area-funktioilla*/

                    koord[0]=edx;   koord[1]=MAXY-1-massaX(m0,edx);
                    koord[2]=x;     koord[3]=MAXY-1-massaX(m0,x);
                    koord[4]=x;     koord[5]=MAXY-1-massaX(med,x);
                    koord[6]=edx;   koord[7]=MAXY-1-massaX(med,edx);
                    koord[8]=koord[0]; koord[9]=koord[1];

                    AreaMove(RP,koord[0],koord[1]);
                    AreaDraw(RP,koord[2],koord[3]);
                    AreaDraw(RP,koord[4],koord[5]);
                    AreaDraw(RP,koord[6],koord[7]);
                    AreaDraw(RP,koord[8],koord[9]);
                    AreaEnd(RP);
                    edx=x;           /* edellinen x talteen */

                    if (x<MAXX/2) x=x+4*dx;   /* vähän nopeutetaan */
                    else if (x<MAXX-5) x=x+dx;
                    else if (x>=MAXX-5) x=x+0.2*dx;
                }
                med=m0;       /* edellinen m0 talteen */
            }
            APU:
            boxi(0,0,MAXX-1,MAXY-1,3);


                                           /* tulostetaan lukuja */
            DiskfontBase = (struct DiskfontBase *)
            OpenLibrary( "diskfont.library", 0 );
            if( !DiskfontBase )
            myexit();

            
            myfont = (struct TextFont *)
            OpenDiskFont( &myfontattr );

            SetFont(RP, myfont );
            SetAPen(RP,0);
            SetDrMd(RP,0);

                                  /* nopeus massa-suhde luvut (nopeus askel)*/

            double c=299792.4562,m,t=0,dt=0.1,t1=0.9,t2=9;
            i=1;
            while( (t<0.99999) && (i<1000) ) {
                m=1/(sqrt(1-t*t));
                tulosta(t,m,"%3.10g     %4.2f\n");
                if (t>=t1*0.9999999999) {
                    i++;
                    dt=1/pow(10,i);
                    t1=t1+t2/pow(10,i);
                    }
                t=t+dt;
            }

            m=1;    i=0;    t1=10;
            dt=1;
                                  /* nopeus-massa suhde luvut (massa-askel)*/
            while( (m<9999) && (i<1000) ) {
                t=sqrt(1-1/(m*m));
                tulosta(t,m,"%3.7f   %7.0f \n");
                if (m>=t1) {
                    i++;
                    dt=pow(10,i);
                    t1=pow(10,i+1);
                }
                m=m+dt;
            }

            while (notDone) {   // "Pääluuppi" jossa ei tehdä mitään
                IntuiMessage *imsg;
                WaitPort(Win->UserPort);
                while (imsg = (IntuiMessage *)GetMsg(Win->UserPort)) {
                    switch(imsg->Class) {
                    case IDCMP_CLOSEWINDOW:
                        notDone = 0;
                        break;
                    }
                    ReplyMsg(&imsg->ExecMessage);
            }
         }
      }
    }
    return(0);
}

void myexit(void)
{
    if (Win) {
        CloseWindow(Win);
        Win = NULL;
    }
    if (Scr) {
        CloseScreen(Scr);
        Scr = NULL;
    }
    if (Pointer) FreeMem(Pointer,RASSIZE(RASX,MAXY));

    if( myfont )
    CloseFont( myfont );

    if( DiskfontBase )
    CloseLibrary( DiskfontBase );
}

