/* Huffman-Codierung mit Codebäumen */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Knoten {
struct Knoten *naechster;
int Anzahl;
short Bit;
};

struct Knoten *Heap[256];
struct Knoten Buchstabe[256];
unsigned long Code[256];
int CodeLaenge[256];
short CodeBaum[512];
unsigned long anzahl;

void versickere(register struct Knoten *a[],int n)
{
register i=0,j;
struct Knoten *t;

	while((j=(i+1<<1)-1)<n)
	{
		if(j<n-1 && a[j]->Anzahl>a[j+1]->Anzahl) j++;
		if(a[i]->Anzahl>a[j]->Anzahl)
		{
			t=a[i];
			a[i]=a[j];
			a[j]=t;
			i=j;
		}
		else break;
	}
}

void zsfassen(struct Knoten *a[],int n)
{
struct Knoten *k,*t;

	k=a[0];
	a[0]=a[--n];
	versickere(a,n);
	t=malloc(sizeof(struct Knoten));
	if(!t)
		exit(10);
	k->naechster=a[0]->naechster=t;
	t->naechster=NULL;
	t->Anzahl=k->Anzahl+a[0]->Anzahl;
	k->Bit=1;
	a[0]->Bit=0;
	a[0]=t;
	versickere(a,n);
}

Knotenvergleich(const void *k1,const void *k2)
{
	return((**(struct Knoten *const*)k1).Anzahl-(**(struct Knoten *const*)k2).Anzahl);
}

zaehle(FILE *fd)
{
register c,n=0;

	anzahl=0;
	while((c=fgetc(fd))>=0)
	{
		if(Buchstabe[c].Anzahl++==0)
			Heap[n++]=&Buchstabe[c];
		anzahl++;
	}

	qsort((void*)Heap,n,sizeof(struct Knoten *),Knotenvergleich);
	return(n);
}

void Code_erstellen(register i)
{
register struct Knoten *k;

	k=&Buchstabe[i];
	Code[i]=CodeLaenge[i]=0;

	while(k->naechster)
	{
		Code[i]|=k->Bit<<CodeLaenge[i]++;
		k=k->naechster;
	}
}

void Code_ausgeben(int i)
{
register j;

	if(Buchstabe[i].Anzahl)
	{
		printf("Zeichen %3d (%5d):\tCode: ",i,Buchstabe[i].Anzahl);
		for(j=CodeLaenge[i]-1;j>=0;j--)
			printf("%c",Code[i]&1<<j?'1':'0');
		putchar('\n');
	}
}

Baum_aufbauen(void)
{
register i,b,c;
int end;

	memset((void*)CodeBaum,0,sizeof(short)*512);
	end=2;
	for(i=0;i<256;i++)
		if(Buchstabe[i].Anzahl)
		{
			c=0;
			for(b=CodeLaenge[i]-1;b>=0;b--)
			{
				if(Code[i] & 1<<b) c++;
				if(!CodeBaum[c])
				{
					if(b)
					{
						CodeBaum[c]=end;
						end=(end&~1)+2;
					}
					else CodeBaum[c]=-i;
				}
				c=CodeBaum[c];
			}
		}
	return(end);
}

void putbit(int bit,FILE *fd)
{
static int bits=7;
static unsigned char byte=0;

	if(bit==1) byte|=1<<bits;
	if(!bits || (bit>1 && bits!=7))
	{
		bits=7;
		fputc(byte,fd);
		byte=0;
	}
	else bits--;
}

void encode(int c,FILE *fd)
{
register bit;
unsigned long code;

	code=Code[c];
	for(bit=CodeLaenge[c]-1;bit>=0;bit--)
		putbit(code&1<<bit?1:0,fd);
}

void Codierung(int n,FILE *fd_in,FILE *fd_out)
{
int c;

	fwrite((void*)&n,sizeof(int),1,fd_out);
	fwrite((void*)CodeBaum,sizeof(short),n,fd_out);
	fwrite((void*)&anzahl,sizeof(unsigned long),1,fd_out);
	while((c=fgetc(fd_in))>=0)
		encode(c,fd_out);
	putbit(2,fd_out);
}

		/****************************/
		/*                          */
		/* Routinen zur Dekodierung */
		/*                          */
		/****************************/


getbit(FILE *fd)
{
static short byte,mask;
static int bits=0;

	if(!bits--)
	{
		if((byte=fgetc(fd))>=0)
		{
			bits=7;
			mask=0x80;
		}
	}
	else mask>>=1;
	return( (byte & mask) >> bits);
}

decode(register short *code,FILE *fd)
{
register c=0;

	do c=code[c+getbit(fd)];
	while(c>0);
	return(-c);
}

void Decodierung(FILE *fd)
{
int n;
short *code;
unsigned long i;

	fread((void*)&n,sizeof(int),1,fd);
	code=malloc(sizeof(short)*n);
	if(!code) exit(10);
	fread((void*)code,sizeof(short),n,fd);
	fread((void*)&anzahl,sizeof(unsigned long),1,fd);
	for(i=0;i<anzahl;i++)
		printf("%c",decode(code,fd));
}

		/* Test-Code */

void main(int argc,char *argv[])
{
FILE *fd1,*fd2;
int n,i;

	if(argc!=3)
	{
		printf("Bad Args\n");
		exit(10);
	}

	fd1=fopen(argv[1],"rt");
	if(!fd1) exit(10);
	fd2=fopen(argv[2],"wb+");
	if(!fd2) exit(10);

	n=zaehle(fd1);
	for(i=n;i>1;i--) zsfassen(Heap,i);
	for(i=0;i<256;i++) Code_erstellen(i);
	for(i=0;i<256;i++) Code_ausgeben(i);
	n=Baum_aufbauen();

	rewind(fd1);
	Codierung(n,fd1,fd2);

	rewind(fd2);
	Decodierung(fd2);
}
