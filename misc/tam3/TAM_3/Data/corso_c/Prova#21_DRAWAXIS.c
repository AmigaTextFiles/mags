/*  21mo programma Apertura di una finestra + rastport  */

/*  4/1/1995	*/

#include <stdio.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>

struct Library *OpenLibrary();
struct IntuitionBase *IntuitionBase;
struct GfxBase *GfxBase;
struct Window *w;
struct XYBase *xyb;
struct RastPort *rp;

char *labels[] =
{
	"1o", "2o", "3o", "4o"
};

struct XYBase
{
	WORD xax;
        WORD yax;
	WORD xlen;
	WORD ylen;
} Assi;

struct NewWindow mywindow =
{
	100,100,
	300,300,
	2,
	1,
	CLOSEWINDOW | NEWSIZE,
	WINDOWDEPTH  | WINDOWDRAG | WINDOWSIZING | WINDOWCLOSE | GIMMEZEROZERO,
        NULL,
	NULL,
	"Come pompa il pippero",
	NULL,
	NULL,
	50,50,
	640,400,
	WBENCHSCREEN
};


main()
{
        GfxBase = (struct GfxBase *)OpenLibrary("graphics.library",0);
	if (GfxBase == 0)
	{
		printf("\nNon posso aprire la GRAPHICS.LIBRARY!");
		exit(20);
	}
	else
	{
                printf("\nHo aperto la GRAPHICS.LIBRARY!");

	}

	IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library",0);
	if (IntuitionBase == 0)
	{
		printf("\nNon posso aprire la INTUITION.LIBRARY!");
		exit(20);
	}
	else
	{
                printf("\nHo aperto la INTUITION.LIBRARY!");

	}

	w = (struct Window *)OpenWindow(&mywindow);
        rp = w->RPort;
        if(rp)
	{
        	printf("\nHo avuto la rastport!");
	}
        else
        {
		printf("\nNon mi dà la rastport!");
	}

	printf("\n\n");
	DrawAxes(rp, 150, 150, 150, 150, 1);
	LabelHorizontal(rp, &labels, 4);
        getchar();

	CloseWindow(w);
	CloseLibrary(IntuitionBase);
        exit(0);
}


DrawAxes(rp, xaxis, yaxis, xlenght, ylenght, color)
struct rastport *rp;
long xaxis, yaxis, xlenght, ylenght, color;
{
	SetAPen(rp, color);

	Move(rp, xaxis, yaxis);
	Draw(rp, xaxis + xlenght, yaxis);
	Move(rp, xaxis, yaxis);
	Draw(rp, xaxis, yaxis + ylenght);

	Assi.xax = xaxis;
        Assi.yax = yaxis;
	Assi.xlen = xlenght;
	Assi.ylen = ylenght;
}


LabelHorizontal(rp, labels, howmany)
struct rastport *rp;
char *labels[];
long howmany;
{
	WORD i, labelwidth, segmentwidth, currentx;
	WORD actualx, actualy;

	segmentwidth = (Assi.xlen) / howmany;
	currentx = Assi.xax;
	actualy = Assi.yax;

	for(i=0; i<howmany; i++)
	{
		printf("\nLabel no. %d: %s", i, labels[i]);
		labelwidth = TextLength(rp, labels[i], strlen(labels[i]));
		labelwidth = labelwidth / 2;
		actualx = currentx + (segmentwidth * i);
		Move(rp, actualx, actualy);
		Text(rp, labels[i], strlen(labels[i]));
	}
}
