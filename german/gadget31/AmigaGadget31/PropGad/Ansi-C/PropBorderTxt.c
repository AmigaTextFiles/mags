/*
:Program.     PropBorderTxt.c
:Contents.    Bindet ein Proportional-Gadget in den rechten Windowrand ein.
:Contents.    Lädt den als erstes Argument angebenen Text und zeigt ihn
:Contents.    abhängig von der Position des Prop-Gadgets im Window an.
:Copyright.   (c) 1996 Sven Drieling
:Language.    Ansi-C
:Translator.  GCC 2.7.2.1 (Amiga)
:History.     V1.0  indy 25-Jun-97

*/

#include <stdio.h>
#include <strings.h>

#include <exec/types.h>
#include <exec/lists.h>
#include <exec/nodes.h>

#include <utility/tagitem.h>

#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <intuition/icclass.h>
#include <intuition/imageclass.h>

#include <graphics/text.h>

#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/graphics.h>

UBYTE *vers = "\0$VER: PropGadget in Border Text 1.0";

struct IntuitionBase *IntuitionBase = NULL;
struct GfxBase       *GfxBase = NULL;

struct Window        *w = NULL;
struct DrawInfo      *drInfo;          /* Enthält Pens etc. */
struct IntuiMessage  *msg;
struct Gadget        *prop, *sizeGad;

struct InnerWindow
{
  LONG minX, minY, maxX, maxY, width, height;
};

struct InnerWindow iw;

UWORD  sizeHeight = 0;   /* Höhe des Sizing-Gadgets                 */
ULONG  lock;             /* Intuition locken                        */
ULONG  top;              /* PGA_TOP auslesen                        */
struct List txt;         /* Text, jede Node ist eine Zeile          */
struct Node *node;
ULONG  numLines = 0;     /* Anzahl der Zeilen des Textes            */
ULONG  visibleLines = 0; /* Anzahl der im Fenster sichtbaren Zeilen */

#define PROPGADGET_ID       1L
#define MINWINDOWWIDTH      50
#define MINWINDOWHEIGHT     50
/**********************************************************/

void GetInnerWindow(struct Window *w, struct InnerWindow *iw)
/*
   Ermittelt die Größe und die Position des inneren Windows(Window ohne
   Rahmen).
*/
{
  if(w != NULL && iw != NULL)
  {
    iw->minX   = w->BorderLeft;
    iw->minY   = w->BorderTop;
    iw->maxX   = w->Width - w->BorderRight - 1;
    iw->maxY   = w->Height - w->BorderBottom - 1;
    iw->width  = iw->maxX - iw->minX + 1;
    iw->height = iw->maxY - iw->minY + 1;
  }
}
/**********************************************************/

void FreeText(void)
{
  while(node = RemHead(&txt))
  {
    if(node->ln_Name) free(node->ln_Name);
    free(node);
  }
}
/**********************************************************/

BOOL ReadText(char *fileName)
/*
   Lädt den mittels Filenamen eingebenen Text. Dabei wird in der Exec-Liste
   "txt" für jede Zeile eine Node angelegt. Die maximale Zeilenlänge
   ist auf 1024 Zeilen begrenzt, um das einlesen des Textes einfacher zu
   gestalten. Die Liste selbst verwaltet die Länge des Textzeilen
   dynamisch. Außerdem werden in numLines die Anzahl der Zeilen gezählt.
*/
{
  char buf[1024]; /* Lesebuffer - Maximale Zeilenlänge 1024 Zeichen */
  BOOL error = FALSE;
  FILE *file;

  numLines = 0;
  NewList(&txt);
  if(file = fopen(fileName, "r"))
  {
    while(!feof(file) && !error)
    {
      error = TRUE;
      if(fgets(buf, 1024, file))  /* Zeile einlesen */
      {
        /*
           Speicher für Node und Zeile reservieren. Der Inhalt der
           Zeile steht in node->ln_Name
        */
        node = (struct Node *) malloc(sizeof(struct Node));
        if(node)
        {
          if(strlen(buf) >= 1) buf[strlen(buf) - 1] = 0; /* \n löschen */
          node->ln_Name = (APTR) malloc(strlen(buf) + 1);
          if(node->ln_Name)
          {
            strcpy(node->ln_Name, buf);
            AddTail(&txt, node);
            numLines++;
            error = FALSE;
          }
        }
      }
    }

    /* Falls Schleifenende durch Ende des Files error auf FALSE setzen */
    if(feof(file)) {error = FALSE;} else {error = TRUE;}
    fclose(file);
    if(error == TRUE)
    {
      FreeText();
      return(FALSE);
    }
    else
    {
      return(TRUE);
    }
  }
}
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

void PrintPage(ULONG firstLine)
/*
   Gibt den Text ab der Zeile firstLine im Fenster aus. Erste Zeile = 0.
   firstLine muß eine gültige Zeile angeben, durch das richtig
   initialisierte Prop-Gadget wird dies sichergestellt.
*/

{
  ULONG cnt;
  ULONG txtLen;
  struct TextExtent te;

  /* Liste bis zur ersten anzuzeigenden Zeile durchgehen */
  node = txt.lh_Head;
  for(cnt = 0; cnt < firstLine; cnt++)
  {
    node = node->ln_Succ;
  }

  /* Window-Inhalt löschen */
  EraseRect(w->RPort, iw.minX, iw.minY, iw.maxX, iw.maxY);

  /*
     Inhalt der sichtbaren Zeilen ausgeben. TextFit() berechnet wieviel
     Zeichen in eine Textzeile passen.
  */
  for(cnt = 0; ((cnt < visibleLines) && (node != NULL)); cnt++)
  {
    Move(w->RPort, iw.minX, iw.minY + cnt * w->RPort->TxHeight +
                              w->RPort->TxBaseline);

    Text(w->RPort, node->ln_Name,
      TextFit(w->RPort, node->ln_Name, strlen(node->ln_Name),
               &te, NULL, 1, iw.width + 1, iw.height));
    node = node->ln_Succ;
  }
}
/**********************************************************/

int main(int argc, char **argv)
{
  BOOL done = FALSE;

  if (IntuitionBase = (struct IntuitionBase *) OpenLibrary("intuition.library", 37L))
  {
    if (GfxBase = (struct GfxBase *) OpenLibrary("graphics.library", 37L))
    {

      if(argc <= 1)
      {
        printf("%s <Dateiname>\n", argv[0]);
        exit(20);
      }

      if(ReadText(argv[1]))
      {

        if(w = OpenWindowTags(NULL,
            WA_Title    , (ULONG) "PropGadget in Border 1.0",
            WA_Flags    , WFLG_DEPTHGADGET | WFLG_DRAGBAR | WFLG_CLOSEGADGET |
                          WFLG_SIZEGADGET,
            WA_IDCMP    , IDCMP_CLOSEWINDOW | IDCMP_IDCMPUPDATE |
                          IDCMP_NEWSIZE,
            WA_MinWidth , MINWINDOWWIDTH,
            WA_MinHeight, MINWINDOWHEIGHT,
            TAG_END))
        {

          /* DrawInfo holen und APen für Textausgabe setzen. Da DrawInfo
             sonst nicht mehr gebraucht wird, wird der Speicher gleich
             wieder freigegeben(ist so übersichtlicher) der Zeiger in
             drInfo ist nach der Freigabe _nicht_ mehr gültig.
          */

          drInfo = GetScreenDrawInfo(w->WScreen);
          if(drInfo)
          {
            SetAPen(w->RPort, drInfo->dri_Pens[TEXTPEN]);
            FreeScreenDrawInfo(w->WScreen, drInfo);
          }

          /* Anzahl der sichtbaren Zeilen berechnen */
          GetInnerWindow(w, &iw);
          visibleLines = iw.height / w->RPort->TxHeight;
          Printf("%i\n", visibleLines);
  
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
                    PGA_Visible,     visibleLines,
                    PGA_Total,       numLines,
                    PGA_Top,         0,
                    TAG_END));
    
          {
            AddGList(w, prop, -1, -1, NULL);  /* Gadget(s) dem Window hinzufügen */
            RefreshGList(prop, w, NULL, -1);  /* Gadget(s) anzeigen              */

            PrintPage(0);     /* Text ausgeben */

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
                    /* Nachricht vom Prop-Gadget bearbeiten */
                    GetAttr(PGA_TOP, prop, &top);
                    PrintPage(top);
                    break;

                  case IDCMP_NEWSIZE:
                    /*
                       Die Größe des Windows wurde verändert. Die neuen
                       Werte des inneren Windows müssen ermittelt,
                       visibleLines neu berechnet, das Prop-Gadget
                       angepaßt und der Text neu ausgegeben werden.
                    */
                    GetInnerWindow(w, &iw);
                    visibleLines = iw.height / w->RPort->TxHeight;
                    SetGadgetAttrs(prop, w, NULL, PGA_Visible, visibleLines,
                                   TAG_END);
                    GetAttr(PGA_TOP, prop, &top);
                    PrintPage(top);
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

        FreeText();
      }

      CloseLibrary((struct Library*) GfxBase);

    }
    CloseLibrary((struct Library*) IntuitionBase);
  }

  return(0);
}
