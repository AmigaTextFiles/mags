/*
:Program.     PropBroder.c
:Contents.    Bindet ein Proportional-Gadget in den rechten Windowrand ein
:Contents.    und gibt die aktuelle Position des Gadget(PGA_TOP) im
:Contents.    Shell-Window aus.
:Contents.    (Beschreibung siehe AmigaGadget #27, Programmieren /
:Contents.     Proportionalgadget mit BOOPSI, Jürgen Klawitter)
:Copyright.   (c) 1996 Sven Drieling
:Language.    Ansi-C
:Translator.  GCC 2.7.2.1 (Amiga)
:History.     V1.0  indy 25-Jun-97
*/

#include <stdio.h>

#include <exec/types.h>

#include <utility/tagitem.h>

#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <intuition/icclass.h>
#include <intuition/imageclass.h>

#include <proto/exec.h>
#include <proto/intuition.h>

UBYTE *vers = "\0$VER: PropGadget in Border 1.0";

struct IntuitionBase *IntuitionBase = NULL;

struct Window        *w = NULL;
struct IntuiMessage  *msg;
struct Gadget        *prop, *sizeGad;

BOOL   done = FALSE;
UWORD  sizeHeight = 0;   /* Höhe des Sizing-Gadgets                 */
ULONG  lock;             /* Intuition locken                        */
ULONG  top;              /* PGA_TOP auslesen                        */

#define PROPGADGET_ID       1L
#define MINWINDOWWIDTH      50
#define MINWINDOWHEIGHT     50
/**********************************************************/

struct Gadget* FindSysGadget(struct Window *w, UWORD gadType)

/*
  Sucht die Gadget-Liste eines Windows durch und liefert den Zeiger
  auf das erste Gadget zurück bei dem g->GadgetType & gadType != NULL ist.
  Falls das Gadget nicht gefunden wird, wird NULL zurückgegeben.
*/

{
  struct Gadget *g = NULL;

  if(w)
  {
    g = w->FirstGadget;
    while(g)
    {
      if(g->GadgetType & gadType)
      {
        return(g);
      }
      g = g->NextGadget;
    }
  }

  return(g);
}
/**********************************************************/

int main(int argc, char **argv)
{
  if (IntuitionBase = (struct IntuitionBase *) OpenLibrary("intuition.library", 37L))
  {
    if(w = OpenWindowTags(NULL,
        WA_Title    , (ULONG) "PropGadget in Border 1.0",
        WA_Flags    , WFLG_DEPTHGADGET | WFLG_DRAGBAR | WFLG_CLOSEGADGET |
                      WFLG_SIZEGADGET,
        WA_IDCMP    , IDCMP_CLOSEWINDOW | IDCMP_IDCMPUPDATE,
        WA_MinWidth , MINWINDOWWIDTH,
        WA_MinHeight, MINWINDOWHEIGHT,
        TAG_END))
    {
      /* Höhe des Sizing-Gadgets ermitteln */
      lock = LockIBase(0);
      sizeGad = FindSysGadget(w, GTYP_SIZING);
      if(sizeGad) sizeHeight = sizeGad->Height;
      UnlockIBase(lock);

      /* PropGadget erstellen */
      if(prop = (struct Gadget *)NewObject(NULL, "propgclass",
                GA_ID,           PROPGADGET_ID,
                GA_Top,          w->BorderTop + 1,
                GA_Width,        w->BorderRight - 6,
                GA_RelRight,     -(w->BorderRight - 3),
                GA_RelHeight,    -(w->BorderTop + sizeHeight + 1),
                GA_RightBorder,  TRUE,
                ICA_TARGET,      ICTARGET_IDCMP,
                PGA_Freedom,     FREEVERT,
                PGA_NewLook,     TRUE,
                PGA_Borderless,  TRUE,
                PGA_Visible,      10,
                PGA_Total,       100,
                PGA_Top,         0,
                TAG_END));

      {
        AddGList(w, prop, -1, -1, NULL);  /* Gadget(s) dem Window hinzufügen */
        RefreshGList(prop, w, NULL, -1);  /* Gadget(s) anzeigen              */

        while(done == FALSE)
        {
          WaitPort((struct MsgPort *)w->UserPort);
          while(msg = (struct IntuiMessage *) GetMsg((struct MsgPort *)w->UserPort))
          {
            switch(msg->Class)
            {
              case IDCMP_CLOSEWINDOW:
                done = TRUE;
                break;

              case IDCMP_IDCMPUPDATE:
                GetAttr(PGA_TOP, prop, &top);
                printf("PGA_TOP = %i\n", top);
                break;
            }

            ReplyMsg((struct Message *) msg);
          }
        }

        RemoveGList(w, prop, -1); /* Gadget(s) wieder entfernen */
        DisposeObject(prop);
      }

      CloseWindow(w);
    }
    CloseLibrary((struct Library*) IntuitionBase);
  }

  return(0);
}
