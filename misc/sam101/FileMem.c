
/* Den här filen består av en massa funktioner som ger minneshantering
 * fast istf i minnet så sker allting i en fil */

#include <dos/dos.h>

#include <clib/dos_protos.h>
#include <pragmas/dos_pragmas.h>

extern struct DosBase *DOSBase;

/* Allokerar "minne" i filen */
ULONG FAllocMem(BPTR File, ULONG Size)
{
ULONG ThisPos,PrevPos,NextPos,FSize,Tmp;

	/* Avrundar size uppåt till jämna 12 bytes */
	Size += (12-1);
	Size -= Size % 12;

	/* Söker rätt på det första lediga minnesblocket */
	Seek(File, 0, OFFSET_BEGINING);
	Read(File, &NextPos, sizeof(ULONG));
	Seek(File, NextPos, OFFSET_BEGINING);
	ThisPos=NextPos;

	/* Läser in minnesheadern för det minnesblocket */
	Read(File, &NextPos, sizeof(ULONG));
	Read(File, &PrevPos, sizeof(ULONG));
	Read(File, &FSize, sizeof(ULONG));

	/* Söker igenom minneslistan tills vid hittar ett ledigt block *
	 * som är stort nog att rymma blocket */
	while(FSize < Size )
	{
		Seek(File, NextPos, OFFSET_BEGINING);
		ThisPos=NextPos;

		Read(File, &NextPos, sizeof(ULONG));
		Read(File, &PrevPos, sizeof(ULONG));
		Read(File, &FSize, sizeof(ULONG));
	};

	if(FSize == Size)
	{
		/* Hela minnesblocket går åt */
		Seek(File, PrevPos, OFFSET_BEGINING);
		Write(File, &NextPos, sizeof(ULONG));

		if(NextPos != NULL)
		{
			Seek(File, NextPos+4,OFFSET_BEGINING);
			Write(File, &PrevPos, sizeof(ULONG));
		}
	}else{
		/* Det blev kvar delar av blocket */
		Tmp=ThisPos+Size;

		Seek(File, PrevPos, OFFSET_BEGINING);
		Write(File, &Tmp, sizeof(ULONG));

		if(NextPos != NULL)
		{
			Seek(File, NextPos+4, OFFSET_BEGINING);
			Write(File, &Tmp, sizeof(ULONG));
		}else{
			/* Vi måste expandera filen så att det sista blocket hamnar rätt */
			SetFileSize(File, Tmp, OFFSET_BEGINING);
		}

		Seek(File, Tmp, OFFSET_BEGINING);
		Write(File, &NextPos, sizeof(ULONG));
		Write(File, &PrevPos, sizeof(ULONG));
		FSize -=Size;
		Write(File, &FSize, sizeof(ULONG));
	}
	return(ThisPos);
}

/* Deallokerar "minne" i filen */
void FFreeMem(BPTR File, ULONG Pos, ULONG Size)
{
ULONG OldPos,FSize,NextPos,ThisPos,PrevPos;

	/* Avrundar size uppåt till jämna 12 bytes */
	Size +=11;
	Size -= Size % 12;

	OldPos=Seek(File, 0L, OFFSET_BEGINING);
	Read(File, &NextPos, sizeof(ULONG));
	Seek(File, NextPos, OFFSET_BEGINING);
	ThisPos=NextPos;

	Read(File, &NextPos, sizeof(ULONG));
	Read(File, &PrevPos, sizeof(ULONG));
	Read(File, &FSize, sizeof(ULONG));

	while(NextPos < Pos)
	{
		Seek(File, NextPos, OFFSET_BEGINING);
		ThisPos=NextPos;

		Read(File, &NextPos, sizeof(ULONG));
		Read(File, &PrevPos, sizeof(ULONG));
		Read(File, &FSize, sizeof(ULONG));
	};

	if(ThisPos+FSize == Pos)
	{
		/* Addera storleken till ThisPos */
		Seek(File, ThisPos+8, OFFSET_BEGINING);
		FSize += Size;
		Write(File, &FSize, sizeof(ULONG));

		return;
	}

	/* Sätter upp det här blocket att peka på oss istället */
	Seek(File, ThisPos, OFFSET_BEGINING);
	Write(File, &Pos, sizeof(ULONG));

	/* Skapar en ny header för det här blocket */
	Seek(File, Pos, OFFSET_BEGINING);
	Write(File, &NextPos, sizeof(ULONG));
	Write(File, &ThisPos, sizeof(ULONG));
	Write(File, &Size, sizeof(ULONG));

	/* Sätter upp nästa block att peka på det nya blocket */
	Seek(File, NextPos+4, OFFSET_BEGINING);
	Write(File, &Pos, sizeof(ULONG));
}

/* Kopierar en del av filen */
void FCopyMem(BPTR File, ULONG From, ULONG To, ULONG Size,
	APTR Buf, ULONG BufSize)
{

	/* Loopar så länge Size är mindre än BufSize */
	while(Size <= BufSize)
	{
		Seek(File, From, OFFSET_BEGINING);
		Read(File, Buf, BufSize);
		Seek(File, To, OFFSET_BEGINING);
		Write(File, Buf, BufSize);

		/* Updaterar pekare */
		From += BufSize;
		To += BufSize;
		Size -= BufSize;
	}

	/* Är Size MOD BufSize == 0? */
	if(Size)
	{
		Seek(File, From, OFFSET_BEGINING);
		Read(File, Buf, Size);
		Seek(File, To, OFFSET_BEGINING);
		Write(File, Buf, Size);
	}
}