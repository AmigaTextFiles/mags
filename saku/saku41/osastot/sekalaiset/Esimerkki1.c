#include <dos/dos.h>
#include <libraries/mui.h>

#include <clib/alib_protos.h>

#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/muimaster.h>

#ifndef MAKE_ID
#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif

struct IntuitionBase *IntuitionBase = NULL;
struct Library       *MUIMasterBase = NULL;

Object   *mainwindow = NULL;
Object   *app        = NULL;

static BOOL Alustus(void)
{
   if (( IntuitionBase  = (struct IntuitionBase *)OpenLibrary("intuition.library", 36)) != NULL )
   if (( MUIMasterBase  = OpenLibrary("muimaster.library", 11)) != NULL )
      return TRUE;
   return FALSE;
}

static void Lopetus(void)
{
   CloseLibrary((struct Library *)IntuitionBase);
   CloseLibrary(MUIMasterBase);
}

int main(void)
{
   int   result   = RETURN_FAIL;
   ULONG signals  = 0;

   /* Avaa systeemikirjastot */

   if (Alustus())
   {
      /* Ensin tarvitsemme application objectin joka toimii juurena */

      app   = ApplicationObject,
         MUIA_Application_Title        , "SAKU",
         MUIA_Application_Version      , "$VER: SAKU 1.0 (1.12.2002)",
         MUIA_Application_Copyright    , "© SAKU, Public Domain",
         MUIA_Application_Author       , "Ilkka Lehtoranta",
         MUIA_Application_Description  , "SAKU testiohjelma",
         MUIA_Application_Base         , "SAKUTESTI",

         /* Määritellään ikkuna */

         SubWindow,  mainwindow  = WindowObject,
            MUIA_Window_Title , "SAKU-ikkuna",
            MUIA_Window_ID    , MAKE_ID('M','A','I','N'),

            /* Ikkuna tarvitsee napit */

            WindowContents, VGroup,          /* VGroup tarkoittaa että seuraavat objektit ryhmitellään allekain */
               Child, TextObject,            /* Tehdään olio jossa on tekstiä */
                  MUIA_Text_Contents, "SAKU",
                  End,
               Child, TextObject,            /* TextObjectista voi tehdä myös nappuloita */
                  MUIA_Text_Contents, "Siistii!",
                  MUIA_Background, MUII_ButtonBack,
                  MUIA_Font, MUIV_Font_Button,
                  MUIA_Frame, MUIV_Frame_Button,
                  MUIA_InputMode, MUIV_InputMode_RelVerify,
                  End,
               End,
            End,
         End;

      if ( app != NULL )
      {
         /* Avataan ikkuna */

         SetAttrs(mainwindow, MUIA_Window_Open, TRUE, TAG_DONE);

         while ( DoMethod(app, MUIM_Application_NewInput, &signals) != MUIV_Application_ReturnID_Quit )
         {
            if ( signals )
            {
               signals  = Wait(signals);
            }
         }

         /* Tuhotaan MUI object tree (sulkee automaattisesti kaikki ikkunat) */

         MUI_DisposeObject(app);

         /* Kaikki meni OK */

         result   = RETURN_OK;
      }
   }

   Lopetus();

   return result;
}

#ifdef __MORPHOS__
const ULONG __abox__ = 1;
#endif /* __MORPHOS__ */
