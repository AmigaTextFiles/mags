/*  22mo programma: disegna una mappa  */

/*  10/1/1995	*/

#include <stdio.h>
#include <exec/types.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <graphics/gfxmacros.h>

#define AZCOLOR 1
#define WHITECOLOR 3
#define NORMALFLAGS (WINDOWSIZING | WINDOWDRAG | WINDOWCLOSE | WINDOWDEPTH)
#define CORNERX 150
#define CORNERY 5

PLANEPTR workspace;

struct Library *OpenLibrary();
struct Window *w;
struct RastPort *rp;
struct Screen *s;
struct ViewPort *vp;
struct IntuitionBase *IntuitionBase;
struct GfxBase *GfxBase;
struct AreaInfo myAreaInfo;
struct TmpRas myTmpRas;

struct TextAttr myfont1 = { "topaz.font",8,0,0 };
struct NewScreen myscreen =
{
	0,0,
	320,200,
	5,
	1, 0,
	0,
	CUSTOMSCREEN,
	&myfont1,
	"32 Color Test",
	NULL,NULL
};

struct NewWindow mywindow =
{
	0,15,
	280,150,
	0,
	1,
	CLOSEWINDOW | NEWSIZE | REFRESHWINDOW,
	SIMPLE_REFRESH | NORMALFLAGS | GIMMEZEROZERO,
        NULL,
	NULL,
	"Come pompa il pippero",
	NULL,
	NULL,
	10,10,
	320,200,
        WBENCHSCREEN
};

HandleEvent(class)
	long class;
	{
		switch(class)
		{
			case CLOSEWINDOW:
				return(0);
				break;
			case NEWSIZE:
				break;
			case REFRESHWINDOW:
				redraw();
				break;
			default:
				break;
		}
		return(1);
	}

WORD areaArray[100];
WORD uthaxy[]		= {0,0,-40,0,-38,-70,-15,-70,-1,55,0,-55,0,0};
WORD coloradoxy[] 	= { 0,0,75,0,75,-55,0,-55 };
WORD arizonaxy[] 	= { 0,0,-40,0,-40,10,-50,10,-50,30,-60,55,-30,70,0,70 };
WORD newmexicoxy[] 	= { 0,0,0,70,8,70,68,70,68,70 };
UWORD mycolortable[] 	= { 0x0000, 0x0e30, 0x0fff, 0x0b40, 0x0fb0, 0x0bf0, 0x05d, 0x0ed0, 0x07df,
			    0x069f, 0x0c0e, 0x0f2e, 0x0feb, 0x0c98, 0x0bbb, 0x07df };

main()
{
	struct IntuiMessage *msg;
	LONG result;
	PLANEPTR workspace;
	WORD rx, ry;

        GfxBase = (struct GfxBase *)OpenLibrary("graphics.library",0);
	IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library",0);

	s = OpenScreen(&myscreen);
	if(s != 0) printf("Ho aperto lo screen\n");
	mywindow.Screen = s;
	w = OpenWindow(&mywindow);
	if (w != 0) printf("La window si è aperta!\n");
	vp = &(s->ViewPort);
	LoadRGB4(vp, mycolortable[0], 16);
	rp = w->RPort;
        workspace = (PLANEPTR)AllocRaster(640,200);
	InitTmpRas(myTmpRas, workspace, RASSIZE(640,200));
	rp->TmpRas = &myTmpRas;
	InitArea(&myAreaInfo, &areaArray[0], 20);
	rp->AreaInfo = &myAreaInfo;
	redraw();

	WaitPort(w->UserPort);

	while(1)
	{
		msg = (struct IntuiMessage *)GetMsg(w->UserPort);

                handleit:
		result = HandleEvent(msg->Class);
		if (result == 0) break;
		msg = (struct IntuiMessage *)GetMsg(w->UserPort);
		if (msg != 0) goto handleit;

		rx = CORNERX - RangeRand(60);
		ry = CORNERY - RangeRand(70);

		if(ReadPixel(rp, rx, ry) == AZCOLOR)
		{
			SetAPen(rp, WHITECOLOR);
			WritePixel(rp, rx, ry);
		}
        }

	CloseWindow(w);
        CloseScreen(s);
        FreeRaster(workspace, 640,200);
}


afill(w, pairs)
WORD *w, pairs;
{
	WORD i;
	AreaMove(rp, CORNERX+w[0], CORNERY+w[1]);
	w++; w++;
	for (i=1; i<pairs; i++)
	{
		AreaDraw(rp, CORNERX+w[0], CORNERY+w[1]);
		w++; w++;
	}
       	AreaEnd(rp);
}

redraw()
{
	SetDrMd(rp, JAM1);
	SetAPen(rp, 1);
	afill(coloradoxy[0], 4);
	SetAPen(rp, 5);
	afill(newmexicoxy[0], 5);
	SetAPen(rp, AZCOLOR);
	afill(arizonaxy[0], 8);
	SetOPen(rp, 12);
	SetAPen(rp, 3);
	DrawDiamond(rp, 20, 20, 20, 10);
	SetAPen(rp, 8);
	DrawDiamond(rp, 20, 120, 20, 10);
	SetAPen(rp, 6);
	SetBPen(rp, 0);
	SetDrMd(rp, JAM1);
	Move(rp, CORNERX-30, CORNERY-20);
	Text(rp, "UT", 2);
	Move(rp, CORNERX-30, CORNERY+30);
	Text(rp, "AZ", 2);
	Move(rp, CORNERX+35, CORNERY-20);
	Text(rp, "CO", 2);
	Move(rp, CORNERX+35, CORNERY+30);
	Text(rp, "MN", 2);
}

DrawDiamond(rport, xcenter, ycenter, xsize, ysize)
struct RastPort *rport;
WORD xcenter, ycenter, xsize, ysize;
{
	BYTE oldAPen;
	WORD xoff, yoff;

	oldAPen = rport->FgPen;
	SetAPen(rport, rport->AOlPen);

	xoff = xsize / 2;
	yoff = ysize / 2;

	Move(rport, xcenter - xoff, ycenter);
	Draw(rport, xcenter, ycenter + yoff);
	Draw(rport, xcenter + xoff, ycenter);
	Draw(rport, xcenter, ycenter - yoff);
	Draw(rport, xcenter - xoff, ycenter);

	Flood(rport, 0, xcenter, ycenter);
	SetAPen(rport, oldAPen);
	return(0);
}