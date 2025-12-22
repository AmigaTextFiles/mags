/*
	Program: Screens and Windows list
	Autor:	LeMUr/FiR3+bla² dla Izviestii #10
	Uwagi:	Patrz artykuî "Listy i podobne struktury danych"
					Izviestia #10, dziaî Software
				Skompilowany pod Sas C 6.50
*/

#include <proto/exec.h>
#include <proto/intuition.h>

#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>

#include <stdio.h>


struct IntuitionBase *IntuitionBase=NULL;


void ShowInfo(struct Screen *screen)
// procedura pokazuje dane o oknach na danym ekranie
{
	struct Window *wnd;

	// pierwsze okno na aktywnym ekranie
	wnd=screen->FirstWindow;
	printf("Okno:\n\tTytuî: '%s'\n"
				"\tWysokoôê: %d\n"
				"\tSzerokoôê: %d\n",
   			wnd->Title,
	   		wnd->Height,
		   	wnd->Width);

	// kolejne okna z aktywnego ekranu
	while(wnd=wnd->NextWindow)
   	printf("Okno:\n\tTytuî: '%s'\n"
	   		"\tWysokoôê: %d\n"
		   	"\tSzerokoôê: %d\n",
			   wnd->Title,
   			wnd->Height,
	   		wnd->Width);
}

int main(void)
{
	ULONG ILock;
	struct Screen *scr;

	if(!(IntuitionBase=(struct IntuitionBase *)OpenLibrary("intuition.library", 0L)))
		return 10;

	ILock=LockIBase(NULL);		// zatrzymanie zmian w intuition

	// pierwszy ekran
	scr=IntuitionBase->FirstScreen;
	printf("Ekran:\n\tTytuî: '%s'\n"
				"\tWysokoôê: %d\n"
				"\tSzerokoôê: %d\n",
				scr->Title,
				scr->Height,
				scr->Width);
	ShowInfo(scr);

	UnlockIBase(ILock);			// odblokowanie zmian w intuition

	// kolejne ekrany
	while(scr=scr->NextScreen)
	{
		printf("\nEkran:\n\tTytuî: '%s'\n"
					"\tWysokoôê: %d\n"
					"\tSzerokoôê: %d\n",
					scr->Title,
					scr->Height,
					scr->Width);
		ShowInfo(scr);
	}

	CloseLibrary((struct Library *)IntuitionBase);
	return 0;
}
