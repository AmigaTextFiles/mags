#include <exec/memory.h>
#include <intuition/intuition.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/intuition.h>
#include <stdio.h>
#include <stdlib.h>

// delkaracje procedur odtwarzajâcych
extern void __asm __saveds STARTMODULE(register __a0 UBYTE *memory);
extern void __asm __saveds STOPMODULE(void);

// zmienne obsîugujâce pamiëê
APTR Bufor=NULL;
ULONG Size=NULL;

// okno i intuition.library
struct IntuitionBase *IntuitionBase=NULL;
struct Window *Okno=NULL;
struct NewWindow mywin=
{
	0, 11,
	250, 11,
	NULL, NULL,
	CLOSEWINDOW,
	WINDOWCLOSE | WINDOWDEPTH | WINDOWDRAG | ACTIVATE | NOCAREREFRESH,
	NULL, NULL,
	(UBYTE *)"Protracker 1.1B player!",
	NULL, NULL,
	NULL, NULL,
	NULL, NULL,
	WBENCHSCREEN
};


void out(int kod)
// Procedura zwalnia co byîo zajëte i wychodzi z podanum kodem bîëdu
// (dostëpny np. poprzez "SET" z CLI).
{
	if(Okno)
		CloseWindow(Okno);

	if(Bufor)
		FreeMem(Bufor, Size);

	if(IntuitionBase)
		CloseLibrary((struct Library *)IntuitionBase);

	exit(kod);
} /* out() */


void main(int argc, char *argv[])
// Caîy program
{
	BPTR file, lock;
	struct FileInfoBlock __aligned fib;

	if(argc!=2)
	{
		printf("I need one argument - a module name!\n");
		out(100);
	}

	// biblioteka...
	if(!(IntuitionBase=(struct IntuitionBase *)OpenLibrary("intuition.library",34L)))
		out(10);

	// okno...
	if(!(Okno=OpenWindow(&mywin)))
		out(20);

	// plik...
	if(!(lock=Lock(argv[1], ACCESS_READ)))
	{
		printf("Unable to lock \"%s\"\n", argv[1]);
		out(25);
	}

	if(!Examine(lock, &fib))
	{
		printf("Unable to examine \"%s\"\n", argv[1]);
		UnLock(lock);
		out(30);
	}

	if(!(Size=fib.fib_Size))
	{
		printf("File couldn't be 0 bytes long!\n");
		UnLock(lock);
		out(32);
	}

	if(!(Bufor=AllocMem(Size, MEMF_CHIP | MEMF_CLEAR)))
	{
		printf("Unable to allocate memory!\n");
		UnLock(lock);
		out(35);
	}

	if(!(file=Open(argv[1], MODE_OLDFILE)))
	{
		printf("Unable to open file \"%s\"\n", argv[1]);
		UnLock(lock);
		out(40);
	}

	Read(file, Bufor, Size);
	Close(file);
	UnLock(lock);

	// gramy!
	printf("And... let's play!\n");
	STARTMODULE(Bufor);

	// pëtla obsîugujâca CloseWindow
	for(;;)
	{
		struct IntuiMessage *imsg;
		ULONG clas;

		WaitPort(Okno->UserPort);

		imsg=(struct IntuiMessage *)GetMsg(Okno->UserPort);
		clas=imsg->Class;

		ReplyMsg((struct Message *)imsg);

		if(clas==CLOSEWINDOW)
		{
			// wyjôcie - zatrzymanie moduîu
			printf("Quit it! Quit it!!!\n");
			STOPMODULE();
			out(0);
		}
	}
}
