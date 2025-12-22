#include <dos/dos.h>
#include <libraries/mui.h>
#include <utility/hooks.h>

#include <clib/alib_protos.h>

#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/muimaster.h>

#ifndef MAKE_ID
#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif

/**********************************************************
 K‰yttˆj‰rjestelm‰kohtaiset makrot
**********************************************************/

#ifdef   __MORPHOS__
#include <emul/emulinterface.h>
#endif

#ifdef   __MORPHOS__
#define MAKEHOOK(name, func)           struct EmulHook name = { NULL, NULL, (HOOKFUNC)& ## (name) ## .emul, NULL, NULL, TRAP_LIB, 0, (void *)(func) };
#else
#define MAKEHOOK(name, func)           struct EmulHook name = { NULL, NULL, (HOOKFUNC)&(func) };
#endif

#ifdef __MORPHOS__
struct EmulHook
{
   struct Hook          hook;
   struct EmulLibEntry  emul;
};
#else
struct EmulHook
{
   struct Hook hook;
};
#endif

/**********************************************************
 Muuttujat
**********************************************************/

struct IntuitionBase *IntuitionBase = NULL;
struct Library       *MUIMasterBase = NULL;

Object   *mainwindow;
Object   *button;
Object   *app;

/**********************************************************
 Tapahtumak‰sittelij‰
**********************************************************/

__saveds static void ButtonEvent(void)
{
   MUI_RequestA(app, NULL, 0, "Tervehdys", "*_OK", "Jee :)\n\n\33bN‰ytt‰‰ toimivan!", NULL);
}

MAKEHOOK(ButtonHook, ButtonEvent)

/**********************************************************
 Ohjelma
**********************************************************/

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

         /* M‰‰ritell‰‰n ikkuna */

         SubWindow,  mainwindow  = WindowObject,
            MUIA_Window_Title , "SAKU-ikkuna",
            MUIA_Window_ID    , MAKE_ID('M','A','I','N'),

            /* Ikkuna tarvitsee napit */

            WindowContents, HGroup,                   /* Huomaa VGroup on vaihtunut HGroupiksi */
               Child, ListviewObject,
                  MUIA_Listview_List, DirlistObject,  /* Dirlist periytyy list-luokasta */
                     MUIA_Dirlist_Directory, "SYS:",
                     MUIA_Frame, MUIV_Frame_InputList,
                     MUIA_CycleChain, 1,
                     End,
                  End,
               Child, BalanceObject, End,             /* Tasapainottaa kahden ryhm‰n v‰lill‰ */
               Child, VGroup,
                  Child, TextObject,
                     MUIA_Text_Contents, "\33cSAKU",
                     End,
                  Child, RectangleObject, End,
                  Child, button = TextObject,
                     MUIA_CycleChain, 1,
                     MUIA_Text_Contents, "\33cSiistii!",
                     MUIA_Background, MUII_ButtonBack,
                     MUIA_Font, MUIV_Font_Button,
                     MUIA_Frame, MUIV_Frame_Button,
                     MUIA_InputMode, MUIV_InputMode_RelVerify,
                     End,
                  End,
               End,
            End,
         End;

      if ( app != NULL )
      {
         /* Aseta tapahtumak‰sittelij‰t */

         DoMethod(mainwindow, MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
            MUIV_Notify_Application, 2, MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit);

         DoMethod(button, MUIM_Notify, MUIA_Pressed, FALSE,
            MUIV_Notify_Self, 2, MUIM_CallHook, &ButtonHook);

         /* Avataan ikkuna */

         SetAttrs(mainwindow, MUIA_Window_Open, TRUE, TAG_DONE);

         while ( DoMethod(app, MUIM_Application_NewInput, &signals) != MUIV_Application_ReturnID_Quit )
         {
            if ( signals )
            {
               signals  = Wait(signals | SIGBREAKF_CTRL_C );

               if ( signals & SIGBREAKF_CTRL_C )
                  break;
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
