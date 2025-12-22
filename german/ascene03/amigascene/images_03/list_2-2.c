/*	Termberechnungsroutine */
/* Zusammenlinken mit Listing 1 (LIFO-Stack)*/
/* Unterstützte Operatoren: + - * / ^ */

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "list_2-1.h"

/*	Die Stapelstrukturen, einer für die Operatoren,
	einer für die noch nicht benützten Werte.
*/

static struct lifo op_stack,val_stack;
int calcerr;	/*globale Variable, die Fehler anzeigt.*/

static rechne(char);

/*	pri gibt die Priorität des angeg. Operators zurück.*/

static pri(char c)
{
static char Ops[][4]={"+-","*/","^"};
register i;

	for(i=0;i<3;i++)
		if(strchr(Ops[i],c)!=NULL)
			break;
	return(i);
}

/*	berechne berechnet den in s angeg. Term und gibt Ergebnis zurück.
	Wenn ein Fehler auftrat, ist calcerr!=0.
*/

double berechne(char *cp)
{
char c,op,*s=cp;
int p,kom,e;
double x;

	lifo(&op_stack,sizeof(char),120);
	lifo(&val_stack,sizeof(double),30);
	calcerr=0;

	while((c=*s)!='\0')
	{
		if(c=='(') push(&op_stack,&c);
		else if(isdigit(c))
		{
			sscanf(s,"%lf",&x);
			for(kom=e=0;(c=*s)!=0;s++)
				if(!isdigit(c)) {
					if(c=='.') {
						if(kom || e) break;
						kom=1;
					}
					else if(c=='e' || c=='E') {
						if(e) break;
						else e=1;
						if(s[1]=='+' || s[1]=='-') s++;
					}
					else break;
				}
			s--;
			push(&val_stack,&x);
		}
		else if(c==')')
			for(;;)
			{
				if(!pop(&op_stack,&c)) {
					calcerr=1;		/*Klammer nie geöffnet.*/
					goto error;
				}
				if(c!='(') {
					if(!rechne(c)) goto error;
				}
				else break;
			}
		else
		{
			p=pri(c);
			if(c=='-' && (s==cp || s[-1]=='(')) c='_',p=4;
			while(!isempty(&op_stack) && (op=*(char*)ontop(&op_stack))!='('\
					&& pri(op)>=p) {
				pop(&op_stack,&op);
				if(!rechne(op)) goto error;
			}
			push(&op_stack,&c);
		}
		s++;
	}
	while(pop(&op_stack,&c)) {
		if(c=='(') {
			calcerr=1;		/*Klammer nicht geschlossen.*/
			goto error;
		}
		if(!rechne(c)) goto error;
	}

	if(!pop(&val_stack,&x)) calcerr=1;
error:
	lifo_(&val_stack);
	lifo_(&op_stack);
	return(x);
}

static rechne(char op)
{
double d1,d2;

	if(op=='_') {
		double *dp=(double*)top(&val_stack);
		if(!dp) return 0;
		*dp=-*dp;
		return 1;
	}
	if(!pop(&val_stack,&d2) || !pop(&val_stack,&d1)) {
		calcerr=1;
		return 0;
	}
	switch(op) {
		case '+': d1+=d2;break;
		case '-': d1-=d2;break;
		case '*': d1*=d2;break;
		case '/': d1/=d2;break;
		case '^': d1=pow(d1,d2);break;
		default:  calcerr=1;return 0;
	}
	push(&val_stack,&d1);
	return 1;
}

void main(argc,argv)
char *argv[];
{
double d;

	if(argc!=2)
	{
		fprintf(stderr,"Kein Infix-Ausdruck angegeben!\n");
		exit(1);
	}
	d=berechne(argv[1]);
	if(calcerr) fprintf(stderr,"Fehler im Term entdeckt.\n");
	else printf("%f\n",d);
}
