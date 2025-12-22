/*
   DrawImage.c
   LeMUr/Fire & blabla
*/
#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/powerpacker.h>

#include <exec/memory.h>
#include <graphics/gfx.h>
#include <libraries/ppbase.h>
#include <intuition/intuition.h>

#include <stdlib.h>
#include <stdio.h>


struct IntuitionBase *IntuitionBase=NULL;
struct GfxBase *GfxBase=NULL;
struct PPBase *PPBase=NULL;


struct Screen *ekran=NULL;
struct Window *okno=NULL;

/* pamiëê i jej rozmiar */
UWORD *Bufor=NULL;
ULONG Size=NULL;

struct NewWindow nokno=
{
   0, 0,
   320, 256,
   0, 0,
   RAWKEY,
   RMBTRAP | NOCAREREFRESH | ACTIVATE | BORDERLESS | BACKDROP,
   NULL, NULL,
   NULL, NULL,
   NULL,
   0, 0,
   0, 0,
   CUSTOMSCREEN
};

struct NewScreen nekran =
{
   0, 0,
   320, 256,
   4,
   0, 0,
   NULL,
   CUSTOMSCREEN,
   NULL, NULL,
   NULL, NULL,
};

struct Image myimage =
{
   0, 0,
   320, 256,
   4,
   NULL,
   0x0F, 0,
   NULL
};

void gout(int kod)
{
   if(okno)
      CloseWindow(okno);
   if(ekran)
      CloseScreen(ekran);

   if(Bufor && Size)
      FreeMem(Bufor, Size);

   if(IntuitionBase)
      CloseLibrary((struct Library *)IntuitionBase);
   if(GfxBase)
      CloseLibrary((struct Library *)GfxBase);
   if(PPBase)
      CloseLibrary((struct Library *)PPBase);

   exit(kod);
}

void main(int argc, char *argv[])
{
   int err;

   if(!(PPBase=(struct PPBase *)OpenLibrary("powerpacker.library", 0L)))
      gout(10);
   if(!(IntuitionBase=(struct IntuitionBase *)OpenLibrary("intuition.library", 34L)))
      gout(10);
   if(!(GfxBase=(struct GfxBase *)OpenLibrary("graphics.library", 34L)))
      gout(10);

   if(err=ppLoadData(argv[1], DECR_NONE, MEMF_CHIP, (UBYTE **)&Bufor, &Size, NULL))
   {
      printf("%s\n", ppErrorMessage(err));
      gout(50);
   }

   if(!(ekran=OpenScreen(&nekran)))
      gout(30);

   LoadRGB4(&ekran->ViewPort, Bufor, 16);

   nokno.Screen=ekran;
   if(!(okno=OpenWindow(&nokno)))
      gout(40);

   ShowTitle(ekran, FALSE);

   myimage.ImageData=Bufor+16;
   DrawImage(okno->RPort, &myimage, 0L, 0L);
   RemakeDisplay();

   /* pëtla obsîugujâca komunikaty intuition */
   for(;;)
   {
      struct IntuiMessage *imsg=NULL;

      WaitPort(okno->UserPort);
      if(imsg=(struct IntuiMessage *)GetMsg(okno->UserPort))
      {
         ULONG clas=imsg->Class;
         UBYTE code=imsg->Code;

         ReplyMsg((struct Message *)imsg);
         /* naciôniëcie ESC */
         if(clas==RAWKEY && code == 69)
            gout(0);
      }
   }
}
