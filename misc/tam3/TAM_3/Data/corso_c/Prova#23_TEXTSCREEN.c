/*  23mo programma: Scritta su schermo */

/*  12/1/1995	*/

#include <stdio.h>
#include <exec/types.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <graphics/gfxmacros.h>
#include <graphics/text.h>

struct GfxBase *GfxBase;
struct IntuitionBase *IntuitionBase;
struct ViewPort *vp;
struct RastPort *rp;
struct Screen *s;
struct Screen *OpenScreen();

#define FONTFLAGS FSF_BOLD

LONG font;
int l;

UWORD colori[] = { 0x0000, 0x0FFF, 0x0FF0, 0x000F };

struct TextAttr myfont = { "XEN.font", 9, 0 };

struct NewScreen myscreen =
{
	0,0,
	640,512,
	2,
	1,0,
	HIRES | LACE,
	CUSTOMSCREEN | HIRES,
	&myfont,
	"Cacao Meravigliao",
	NULL,
	NULL,
};

main()
{
	GfxBase = (struct GfxBase *)OpenLibrary("graphics.library", 0);
	if (GfxBase != 0) printf("\nHo aperto la graphics.library");

	IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library", 0);
	if (IntuitionBase != 0) printf("\nHo aperto l' intuition.library");

	s = OpenScreen(&myscreen);
	if (s != 0) printf("\nHo aperto lo screen");

	rp = &(s->RastPort);
	if (rp != 0) printf("\nHo preso la rastport");

        vp = &(s->ViewPort);
	if (vp != 0) printf("\nHo preso la viewport");

        LoadRGB4(vp, &colori, 4);

        SetAPen(rp, 1);
	SetDrMd(rp, JAM1);
	SetRast(rp, 0);

	font = OpenDiskFont(&myfont);
	if (font != 0) printf("\nHo aperto il font");
        SetFont(rp, font);
	SetSoftStyle(rp, FONTFLAGS, 0xFF);
        l = TextLength(rp, "Ciao... Questa è una prova!", 27);
        Move(rp, 320-(l/2), 256);
        Text(rp, "Ciao... Questa è una prova!", 27);

	getchar();
	CloseFont(font);
	CloseLibrary(GfxBase);
	CloseLibrary(IntuitionBase);
        CloseScreen(s);

}
