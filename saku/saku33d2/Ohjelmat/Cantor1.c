
/*
Kaikki kokonaisluvut n=0,1,2,...,miljoona,...,n+1,...,miljardi^miljardi,...
ovat kuvattavissa yksik‰sitteisesti mille tahansa v‰lille a:sta b:hen esim.
kuvauksella f(n)=b-(b-a)/(n+1), vaikka a ja b olisivat kuinka l‰hell‰
toisiaan esim. a=1/(miljardi+1) ja b=1/miljardi.
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
#define depth 5
int cols;
struct TmpRas TmpRas;
PLANEPTR Pointer;
double koord[10];
UBYTE AreaBuffer[(5+1)*5];
struct AreaInfo AreaInfo;
#define MAXX 640
#define RASX 640
#define MAXY 256
#define scrid  0x8000 //0x0000 //0x89024
char buf1[256];
char title[256]={"Kokonaislukukuvaus N->[a...b]: f(n)=b-(b-a)/(n+1)"};
struct NewScreen Ns = {
  0,            /* LeftEdge */
  0,            /* TopEdge */
  MAXX,         /* Width   */
  MAXY,         /* Height  */
  depth,        /* Depth   */
  0,            /* DetailPen */
  1,            /* BlockPen  */
  scrid,      /* ViewModes */
  CUSTOMSCREEN, /* Type */
  NULL,         /* Font */
  title,
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
  WFLG_BORDERLESS|
  WFLG_DRAGBAR,
  NULL,         /* FirstGadget  Ei k‰yttˆ‰. */
  NULL,         /* CheckMark    Ei customia */
  title,
  NULL,         /* Screen       Asetetaan screenin avauksen j‰lkeen*/
  NULL,         /* BitMap       Ei custom-bitmappia */
  0,            /* MinWidth     Ei k‰yttˆ‰ koska ei SIZEGADGETti‰*/
  0,            /* MinHeight    */
  0,            /* MaxWidth     */
  0,            /* MaxHeight    */
  CUSTOMSCREEN  /* Type*/
};
struct TextFont *myfont;
struct Library *DiskfontBase;
#define fkor 8
#define RP   Win->RPort
#define BText Text(RP,buf1,strlen(buf1))
struct TextAttr myfontattr=           /* vaihda toinen fontti...*/
{      /* t‰ss‰ k‰ytet‰‰n Topazia vain siksi ett‰ ohjelma ei kaadu fontin
                                                             puutteeseen*/
  "Topaz.font", /* Name of the font.  */
  fkor,          /* Height (in pixels) */
  FS_NORMAL,   /* Style              */
  FPF_DISKFONT /* Exist on Disk.     */
};

int lkm=20; //0..lkm-1
int maxx=MAXX-5*fkor;
double yk,yma,ymy;
double tx,mtx,mtx0;
double tl;
double i,a=0.8,b=0.9,fi;

void myexit(void);
void Piirra(void);
void main(ac, av)
int ac;
char *av[];
{
    short notDone = 1;
    atexit(myexit);

    if (ac == 1) {
        puts("cantor1.exe <lkm> <a> <b>, jossa a<b esim. cantor1.exe 20 18.3 18.8");
        exit(1);
    }
    lkm=atof(av[1]);
    a=atof(av[2]);
    b=atof(av[3]);
   

    if (a>=b) {
        puts("a<b");
        exit(1);
    }

    if (lkm<1) {
        puts("lkm>1");
        exit(1);
    }

    if (Scr = OpenScreen(&Ns)) {
        Nw.TopEdge= 0;
        Nw.Height = Scr->Height - Nw.TopEdge;
        Nw.Width  = Scr->Width;

        Nw.Screen = Scr;
        cols=fpow(2.0,depth);

        if (Win = OpenWindow(&Nw))  {
//Tehty RGBmaker:lla
SetRGB32(&Scr->ViewPort,0,0<<24,0<<24,0<<24);
SetRGB32(&Scr->ViewPort,1,255<<24,255<<24,255<<24);
SetRGB32(&Scr->ViewPort,2,255<<24,251<<24,246<<24);
SetRGB32(&Scr->ViewPort,3,255<<24,247<<24,237<<24);
SetRGB32(&Scr->ViewPort,4,255<<24,243<<24,228<<24);
SetRGB32(&Scr->ViewPort,5,255<<24,239<<24,219<<24);
SetRGB32(&Scr->ViewPort,6,255<<24,234<<24,209<<24);
SetRGB32(&Scr->ViewPort,7,255<<24,230<<24,200<<24);
SetRGB32(&Scr->ViewPort,8,255<<24,226<<24,191<<24);
SetRGB32(&Scr->ViewPort,9,255<<24,222<<24,182<<24);
SetRGB32(&Scr->ViewPort,10,255<<24,218<<24,173<<24);
SetRGB32(&Scr->ViewPort,11,255<<24,214<<24,164<<24);
SetRGB32(&Scr->ViewPort,12,255<<24,210<<24,155<<24);
SetRGB32(&Scr->ViewPort,13,255<<24,206<<24,146<<24);
SetRGB32(&Scr->ViewPort,14,255<<24,202<<24,137<<24);
SetRGB32(&Scr->ViewPort,15,255<<24,197<<24,127<<24);
SetRGB32(&Scr->ViewPort,16,255<<24,193<<24,118<<24);
SetRGB32(&Scr->ViewPort,17,255<<24,189<<24,109<<24);
SetRGB32(&Scr->ViewPort,18,255<<24,185<<24,100<<24);
SetRGB32(&Scr->ViewPort,19,255<<24,181<<24,91<<24);
SetRGB32(&Scr->ViewPort,20,255<<24,177<<24,82<<24);
SetRGB32(&Scr->ViewPort,21,255<<24,173<<24,73<<24);
SetRGB32(&Scr->ViewPort,22,255<<24,169<<24,64<<24);
SetRGB32(&Scr->ViewPort,23,255<<24,165<<24,55<<24);
SetRGB32(&Scr->ViewPort,24,255<<24,161<<24,46<<24);
SetRGB32(&Scr->ViewPort,25,255<<24,156<<24,36<<24);
SetRGB32(&Scr->ViewPort,26,255<<24,152<<24,27<<24);
SetRGB32(&Scr->ViewPort,27,255<<24,148<<24,18<<24);
SetRGB32(&Scr->ViewPort,28,255<<24,144<<24,9<<24);
SetRGB32(&Scr->ViewPort,29,255<<24,140<<24,0<<24);
SetRGB32(&Scr->ViewPort,30,153<<24,50<<24,204<<24);
SetRGB32(&Scr->ViewPort,31,139<<24,0<<24,0<<24);


            DiskfontBase = (struct DiskfontBase *)
            OpenLibrary( "diskfont.library", 0 );

            myfont = (struct TextFont *)
            OpenDiskFont( &myfontattr );

            SetFont(RP, myfont );
                    Pointer=AllocRaster(RASX,MAXY);
            InitTmpRas(&TmpRas,Pointer,RASSIZE(RASX,MAXY));
            RP->TmpRas=&TmpRas;

            InitArea(&AreaInfo,AreaBuffer,(4+1)*5);
            RP->AreaInfo=&AreaInfo;
            Piirra();
              while (notDone) {
                      IntuiMessage *imsg;
                      WaitPort(Win->UserPort);
                      while (imsg = (IntuiMessage *)GetMsg(Win->UserPort)) {
                          switch(imsg->Class) {
                          case IDCMP_CLOSEWINDOW:
                              notDone = 0;
                              break;
                          case IDCMP_MOUSEBUTTONS:
                              a=a++;b++;
                              Piirra();
                          }
                          ReplyMsg(&imsg->ExecMessage);
                         
                      }
              } //while notDone
        } // Win
    }//Scr

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

void Piirra(void)
{
            SetAPen(RP,0);
            RectFill(RP,0,10,MAXX,MAXY);
            yk=MAXY/3;
            ymy=12+3*fkor;
            yma=yk+yk-ymy;
            mtx0=0.05*maxx;
            tl=TextLength(RP,"f(345)=89.012345BB",17);

             SetAPen(RP,cols-1);
              AreaMove(RP,mtx0,yma-4);
              AreaDraw(RP,maxx-mtx0,yma-4);
              AreaDraw(RP,(b/lkm)*maxx,yk+2);
              AreaDraw(RP,(a/lkm)*maxx,yk+2);
              AreaDraw(RP,mtx0,yma-4);
              AreaEnd(RP);

              RectFill(RP,koord[0],koord[1],koord[2],koord[3]+4);
              SetAPen(RP,cols-2);
              RectFill(RP,koord[6],koord[7]-4,koord[4],koord[5]);
              SetAPen(RP,cols-1);

              AreaMove(RP,(a/lkm)*maxx,yk-2);
              AreaDraw(RP,(b/lkm)*maxx,yk-2);
              AreaDraw(RP,maxx-mtx0,ymy+4);
              AreaDraw(RP,mtx0,ymy+4);
              AreaDraw(RP,(a/lkm)*maxx,yk-2);
              AreaEnd(RP);

              RectFill(RP,koord[6],ymy+1,koord[4],ymy+4);
              int rlkm=(MAXY-yma)/fkor-1;
              for (i=0;i<=lkm;i++)
              {
                  fi=b-((b-a)/(i+1.0));
                  tx=maxx*(fi-a)/(b-a);
                  mtx=mtx0+0.9*maxx*(fi-a)/(b-a);

                  //f(n)=14.23434

                  SetAPen(RP,(int)(i+1.1));
                  sprintf(buf1,"f(%d)=%lf",(int)i,fi);
                  Move(RP,mtx,yma+2*fkor+fkor*((int)i%rlkm));
                  BText; //Text(RP,buf1,strlen(buf1));

                  Move(RP,(i/lkm)*maxx,yk-2);     //kokonaisluku koord
                  Draw(RP,(i/lkm)*maxx,yk+2);

                  
                  Draw(RP,mtx,yma-4); //murtoluku koord  ok
                  Draw(RP,mtx,yma+4);

                  Move(RP,(fi/lkm)*maxx,yk+2); //murtoluku koord kokonaislukuaks.
                  Draw(RP,(fi/lkm)*maxx,yk-2);
                  Draw(RP,mtx,ymy+4);
                  Draw(RP,mtx,ymy-4);
              }


              for (i=0;i<=lkm;i++)
              {
                  SetAPen(RP,(int)(i+1));           //kokonaisluvut siirrettiin alusta t‰nne
                  sprintf(buf1,"%d",(int)i);
                  Move(RP,(i/lkm)*maxx,yk-fkor);
                  BText;

              }

              SetAPen(RP,cols-3);    //  Vaakaviivat
              Move(RP,0,yk);    //kokonaisluvut
              Draw(RP,MAXX,yk);

              SetAPen(RP,cols-2);
              Move(RP,mtx0,yma);    //murtoluvut alh.
              Draw(RP,maxx-mtx0,yma);

              SetAPen(RP,cols-2);
              Move(RP,mtx0,ymy);    //murtoluvut ylh.
              Draw(RP,maxx-mtx0,ymy);

              for(i=a; i<=b; i=i+((b-a)/10))
              {
                 //murtoluku-akseli ylh‰‰ll‰
                 mtx=mtx0+0.9*maxx*(i-a)/(b-a);

                 sprintf(buf1,"%1.2lf",i);
                 Move(RP,mtx,ymy-fkor);
                 BText;

                 Move(RP,mtx,ymy+2);
                 Draw(RP,mtx,ymy-2);

                 //murtolukuakseli alhaalla
                 sprintf(buf1,"%1.2lf",i);
                 Move(RP,mtx,yma+fkor);
                 BText;

                 Move(RP,mtx,yma+2);
                 Draw(RP,mtx,yma-2);
              }
              //-------------------------------------------------------------
              
              i=lkm; 
              rlkm=rlkm-1;
              int sara;
              do {
                  fi=b-((b-a)/i);
                  
                  SetAPen(RP,1+(int)i%(cols-4));
                  sprintf(buf1,"f(%d)=%lf",(int)(i+1),fi);
                  sara=(int)((i-lkm)/rlkm);
                  Move(RP,tl*sara,yma+(3+sara)*fkor+fkor*((int)(i-lkm)%rlkm));
                  BText;
                  i++;
              } while(tl*(int)((i-lkm)/rlkm)<maxx-20*fkor);
              //



}

