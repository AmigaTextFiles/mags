/*  Sedicesimo programma: DateStamp  */

/*  2/1/95   */


#include <stdio.h>
#include <libraries/dosextens.h>

char *mesi[] =
{
	"", "Gennaio", "Febbraio", "Marzo", "Aprile", "Maggio", "Giugno",
        "Luglio", "Agosto", "Settembre", "Ottobre", "Novembre", "Dicembre",
};

long n;
int giorno, mese, anno;

main()
{
	long *v;
	DateStamp(v);
	ShowDate(v);
}

ShowDate(v)
long *v;
{
	long n;
	int giorno, mese, anno;
	n = v[0] - 2251;

	anno = (4 * n + 3) / 1461;
	n -= 1461 * (long) anno/4;
	anno += 1984;
	mese = (5 * n + 2) / 153;
	giorno = n - (153 * mese + 2) / 5 + 1;
        mese += 3;
	anno++;
	mese -= 12;
	printf("DateStamp: %ld\n", v[0]);
	printf("%s %d %d\n", mesi[mese], giorno, anno);
	return(0);
}
