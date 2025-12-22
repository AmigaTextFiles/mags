
/* Käytetty Cantor artikkelin (Zöözi kanttori) kuvien tuottamiseen
parametrina annetaan - tai ei anneta - 1, 2 tai 3...*/

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
#define scrid  0x8000 //0x0000 // //0x89024
#define RP   Win->RPort
int cols;
struct TmpRas TmpRas;
PLANEPTR Pointer;
#define RASX MAXX
double koord[10]; 
UBYTE AreaBuffer[(5+1)*5];
struct AreaInfo AreaInfo;

struct Library *DiskfontBase;
#define fkor 8
struct TextAttr myfontattr=     /* vaihda toinen fontti ... */
{
  "Topaz.font", /* Name of the font.  */
  fkor,          /* Height (in pixels) */
  FS_NORMAL,   /* Style              */
  FPF_DISKFONT /* Exist on Disk.     */
};

struct TextFont *myfont;
char title[256]={"Murtolukujen numerointi."};
struct NewScreen Ns = {
  0,            /* LeftEdge */
  0,            /* TopEdge */
  MAXX,         /* Width   */
  MAXY,         /* Height  */
  depth,        /* Depth   */
  0,            /* DetailPen */
  4,            /* BlockPen  */
  scrid,      /* ViewModes */
  CUSTOMSCREEN, /* Type */
  NULL,         /* Font */
  title,         /* Title */
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
  IDCMP_CLOSEWINDOW|IDCMP_MOUSEBUTTONS, /* IDCMPFlags */
  WFLG_CLOSEGADGET|  /* Flags*/
  WFLG_ACTIVATE|
  WFLG_BORDERLESS,
  NULL,         /* FirstGadget  Ei käyttöä. */
  NULL,         /* CheckMark    Ei customia */
  title,        /* Title */
  NULL,         /* Screen       Asetetaan screenin avauksen jälkeen*/
  NULL,         /* BitMap       Ei custom-bitmappia */
  0,            /* MinWidth     Ei käyttöä koska ei SIZEGADGETtiä*/
  0,            /* MinHeight    */
  0,            /* MaxWidth     */
  0,            /* MaxHeight    */
  CUSTOMSCREEN  /* Type*/
};
double slev0,slev,rkor,rkor0;
float sX(float s)
{
    return(slev0+s*slev);
}
float rY(float r)
{
    return(rkor0+r*rkor);

}
float kiertoX(float alfa,float x,float y)
{
    x=slev*x;
    y=slev*y;
    return(cos(alfa)*x+sin(alfa)*y*1.9);

}
float kiertoY(float alfa,float x,float y)
{
    x=slev*x;
    y=slev*y;
    return(-sin(alfa)*x/1.9+cos(alfa)*y);

}
void myexit(void);
main(ac, av)
int ac;
char *av[];
{
    printf("Cantor2.exe 1, 2 tai 3\n");
    int para=atoi(av[1]);
    if (para < 1 || para>3 || ac==1) para=3;

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
//Tehty RGBmaker:lla
SetRGB32(&Scr->ViewPort,0,28<<24,63<<24,163<<24);
SetRGB32(&Scr->ViewPort,1,6<<24,90<<24,185<<24);
SetRGB32(&Scr->ViewPort,2,246<<24,162<<24,109<<24);
SetRGB32(&Scr->ViewPort,3,236<<24,246<<24,223<<24);
SetRGB32(&Scr->ViewPort,4,83<<24,183<<24,144<<24);
SetRGB32(&Scr->ViewPort,5,255<<24,255<<24,255<<24);
SetRGB32(&Scr->ViewPort,6,126<<24,73<<24,67<<24);
SetRGB32(&Scr->ViewPort,7,200<<24,89<<24,57<<24);
SetRGB32(&Scr->ViewPort,8,236<<24,221<<24,11<<24);
SetRGB32(&Scr->ViewPort,9,51<<24,178<<24,86<<24);
SetRGB32(&Scr->ViewPort,10,79<<24,255<<24,0<<24);
SetRGB32(&Scr->ViewPort,11,222<<24,186<<24,188<<24);
SetRGB32(&Scr->ViewPort,12,113<<24,165<<24,28<<24);
SetRGB32(&Scr->ViewPort,13,10<<24,228<<24,132<<24);
SetRGB32(&Scr->ViewPort,14,155<<24,49<<24,255<<24);
SetRGB32(&Scr->ViewPort,15,24<<24,139<<24,214<<24);
SetRGB32(&Scr->ViewPort,16,0<<24,0<<24,0<<24);

            SetAPen(RP,0);                  /* ruudun tyhjennys */
            RectFill(RP,0,0,MAXX-1 ,MAXY-1);

            DiskfontBase = (struct DiskfontBase *)
            OpenLibrary( "diskfont.library", 0 );
            if( !DiskfontBase )
            myexit();

            
            myfont = (struct TextFont *) OpenDiskFont( &myfontattr );
            if (!myfont) {
                printf("Fontti puuttuu\n"); myexit();
            }
            SetFont(RP, myfont );
            SetDrMd(RP,0);

            double maxx=MAXX,maxy=MAXY;
            char buf1[256];
            int rvari=5,svari=3;

            

            slev=1.2*TextLength(RP,"99/99",5);
            slev0=TextLength(RP,"99",2);
            rkor=(0.2+para+(para==3))*fkor;
            rkor0=12+fkor;

            double sara=maxx/slev, rivi=maxy/rkor;

            int i,s=1,r=1, edr=1,eds=1,dr=-1,ds=1,p;
            float nkx,nky,alfa;
            short neg;
            i=1;
            if (para==1) goto yli1;
            do {
                SetAPen(RP,7);              //suunta viivat

                nky=(para==3)*0.25+0.25;   //0.25 tai 0.5
                nkx=fkor*(0.6+0.6*(para==3));
                for(p=-1;p<2;p++) {
                Move(RP,sX(s-0.5),rY(r-nky)+p);
                Draw(RP,sX(eds-0.5),rY(edr-nky)+p);
                }
                for(p=-2;p<3;p++) {
                Move(RP,p+sX(s-0.5),rY(r-nky));
                Draw(RP,p+sX(eds-0.5),rY(edr-nky));
                }
                                            //järj. numero ellipsi
                AreaEllipse(RP,sX(s-0.5),rY(r-nky),1.5*fkor,(0.5+0.5*(para==3))*fkor);
                AreaEnd(RP);

                if (r>1 || s>1) {
                nkx=(sX(eds-0.5)+sX(s-0.5))/2;
                float nkyapu=nky;
                nky=(rY(edr-nkyapu)+rY(r-nkyapu))/2;//suuntanuolet

                if (eds != s ) alfa=fatan(-(r-edr)/(s-eds));
                else alfa=fatan(-99);
                neg=1-2*(eds>s);

                SetAPen(RP,8);

Move(RP,nkx+neg*kiertoX(alfa,-0.1,0.07),nky+neg*kiertoY(alfa,-0.1,0.07));
Draw(RP,nkx+neg*kiertoX(alfa,0.3,0),nky+neg*kiertoY(alfa,0.3,0));
Draw(RP,nkx+neg*kiertoX(alfa,-0.1,-0.07),nky+neg*kiertoY(alfa,-0.1,-0.07));
}

                edr=r;
                eds=s;

                r=r+dr;
                s=s+ds;

                if (r<1) {r=1; dr=1; ds=-1;}
                if (s<1) {s=1; ds=1; dr=-1;}

            } while(r<rivi || s<sara);
            //Sama luuppi uudestaan numerointia varten ja tutkitaan jaollisuus
            double kkapu;
            int a,b,c,syti;
            r=1, s=1;
            edr=1,eds=1,dr=-1,ds=1;
            i=1; syti=0;
            int dx,dy;
            do {

                SetAPen(RP,6);
                sprintf(buf1,"%d",i++);      //järjestysnumero
                kkapu=sX(s-1)+(slev-TextLength(RP,buf1,strlen(buf1)))/2;
                Move(RP,kkapu,rY(r-1)+2*fkor);
                Text(RP,buf1,strlen(buf1));
                if (para<3) goto yli3;
                // Tutkitaan onko yhteisiä tekijöitä, jolloin luku on
                // jo lueteltu: i/j luetellaan aina ennen kuin (n*i)/(n*j)
                // missä n=syt(i,j)
                a=r;b=s;
                if (a<b) {
                    a=s;
                    b=r;
                }
                c=1;
                while(c!=0) {    //a:han tulee a:n ja b:n suurin yhteinen
                                 //tekijä joka voidaan sieventää a/b:stä
                    c=a%b;
                    a=b;
                    b=c;
                }

                if (a!=1) {
                    b=s/a;
                    a=r/a;
                }
                else   {
                    a=r;
                    b=s;
                    syti++;
                }
                SetAPen(RP,2);
                sprintf(buf1,"%d",syti);   // uusi järjestysnumero
                kkapu=sX(s-1)+(slev-TextLength(RP,buf1,strlen(buf1)))/2;
                Move(RP,kkapu,rY(r-1)+3*fkor);
                Text(RP,buf1,strlen(buf1));

                // sievennetyt r/s
                if (b!=1) {
                sprintf(buf1,"%d/%d",a,b);
                } else {
                    sprintf(buf1,"%d",a);
                }
                kkapu=sX(s-1)+(slev-TextLength(RP,buf1,strlen(buf1)))/2;

                sprintf(buf1,"%d",a);
                Move(RP,kkapu,rY(r-1)+4*fkor);

                SetAPen(RP,rvari-1);
                Text(RP,buf1,strlen(buf1));
                if (b!=1) {
                    SetAPen(RP,1);
                    Text(RP,"/",1);
                    sprintf(buf1,"%d",b);
                    SetAPen(RP,svari+6);
                    Text(RP,buf1,strlen(buf1));
                }
yli3:           edr=r;
                eds=s;

                r=r+dr;
                s=s+ds;
                if (r<1) {r=1; dr=1; ds=-1;}
                if (s<1) {s=1; ds=1; dr=-1;}
            } while(r<rivi || s<sara);

yli1:

            for (r=0; r<rivi;r++) {
                SetAPen(RP,1);               //x-viivat
                Move(RP,slev0,rY(r));
                Draw(RP,maxx,rY(r));

                SetAPen(RP,rvari);              //rivi-numerot 0-sarakkeella
                sprintf(buf1,"%d",r+1);
                Move(RP,0,rY(r+1)-(rkor-fkor)/2);
                Text(RP,buf1,strlen(buf1));
            }

            for (s=0; s<sara;s++)  {        //y-viivat
                SetAPen(RP,1);
                Move(RP,sX(s),rkor0);
                Draw(RP,sX(s),maxy);

                SetAPen(RP,svari);             //sarake-numerot 0-rivillä
                sprintf(buf1,"%d",s+1);
                Move(RP,sX(s)+(slev-TextLength(RP,buf1,strlen(buf1)))/2,0.9*rkor0);
                Text(RP,buf1,strlen(buf1));

                int vi=7,vj=6;
                for (r=0; r<rivi;r++) {    // i/j
                    /*       Tarvittiin neliöiden värityksessä kuvaan 5
                    SetAPen(RP,0);
                    if (s+1<vi+vj && r+1<vi+vj) {
                        SetAPen(RP,9);
                    }
                    if(r+1<=vi && s+1<=vj) {
                        SetAPen(RP,2);
                    }
                    if (r+s+2==vi+vj) {
                        SetAPen(RP,vj);
                    }
                    if (s+1>vj && r+s+2<vi+vj) {
                        SetAPen(RP,7);
                    }
                    if (r+1>vi && r+s+2<vi+vj) {
                        SetAPen(RP,8);
                    }
                    if (r+1==vi && s+1==vj) {
                        SetAPen(RP,10);
                    }
                   
                    RectFill(RP,sX(s)+1,rY(r)+1,sX(s+1)-1,rY(r+1)-1);
                    */

                    sprintf(buf1,"%d/%d",r+1,s+1);
                    kkapu=sX(s)+(slev-TextLength(RP,buf1,strlen(buf1)))/2;

                    sprintf(buf1,"%d",r+1);
                    Move(RP,kkapu,rY(r)+fkor);

                    SetAPen(RP,rvari);
                    Text(RP,buf1,strlen(buf1));
                    SetAPen(RP,1);
                    Text(RP,"/",1);
                    sprintf(buf1,"%d",s+1);
                    SetAPen(RP,svari);
                    Text(RP,buf1,strlen(buf1));

                }
            }

if (para<3) goto yli2;
            // vielä kerran peittoamista varten

            r=1; s=1; dr=-1; ds=1; i=1; syti=0;
            do {
                i++;
                a=r;b=s;
                if (a<b) {
                    a=s;
                    b=r;
                }
                c=1;
                while(c!=0) {    //a:han tulee a:n ja b:n suurin yhteinen
                                 //tekijä joka voidaan sieventää a/b:stä
                    c=a%b;
                    a=b;
                    b=c;
                }

                if (a!=1) {
                    b=s/a;
                    a=r/a;
                    if (r<=rivi && s<=sara) {
                    SetAPen(RP,10);
                    for(dy=rY(r-1); dy<=rY(r); dy=dy+2)
                        for(dx=sX(s-1)+2*(dy%4); dx<=sX(s); dx=dx+8)
                            WritePixel(RP,dx,dy);
                    }
                }   /*
                else   {
                    a=r;
                    b=s;
                    syti++;
                } */

                edr=r;
                eds=s;

                r=r+dr;
                s=s+ds;
                if (r<1) {r=1; dr=1; ds=-1;}
                if (s<1) {s=1; ds=1; dr=-1;}
            } while(r<rivi || s<sara);

            //myfontattr.ta_YSize=11;
            //myfont = (struct TextFont *) OpenDiskFont(&myfontattr);
            //SetFont(RP, myfont );
yli2:
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

