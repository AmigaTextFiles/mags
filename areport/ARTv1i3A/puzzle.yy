%option noyywrap
%{
#include <stdio.h>
%}
CONS	[BCDFGHJKLMNPQRSTVWXYZbcdfghjklmnpqrstvwxyz]*
%%
 /*grammatical definition for words with consonants occuring in reverse order */
{CONS}u{CONS}o{CONS}i{CONS}e{CONS}a{CONS}   {printf("%s\n",yytext);}
 /*grammatical definition for words with consonants occuring in natural order */
{CONS}a{CONS}e{CONS}i{CONS}o{CONS}u{CONS}   {printf("%s\n",yytext);}
\n	{}
.	{}
%%

int main(int argc, char** argv)
{
/* file I/O is the primary focus of this Main function */
  FILE* infile;
  int   filelen, count; 
  char* filename;
  char* num;

  /* If the correct command was not entered print correct usage */
  if(argc < 2) {
    fprintf(stderr, "Usage: %s [filename]\n", argv[0]);
    exit(1);
  };

  filename = argv[1];

  /* If the input file could not be opened give an error message */
  if ((infile = fopen(filename, "r"))==NULL)
    {
      fprintf(stderr, "Error: file %s does not exist\n", filename);
      exit(-1);
    }
  filelen = strlen(filename);

  yyin = infile;	/* set so the input of Flex equals the file stream */
  yylex();		/* function called to parse the input for the gramm-
			   atical patterns */

  fclose(infile);
}
