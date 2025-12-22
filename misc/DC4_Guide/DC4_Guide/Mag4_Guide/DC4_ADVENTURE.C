/*
   Adventure
    (c)1997 Mark Harman

    C++, Compiled using GNU-C

*/

// Preprocessor crap

#include <stdio.h>
#include <stdlib.h>   // for rand()
#include <string.h>   // for strcpy()

// Constants

const int NOSTATS=5;

// Structure Declarations

struct character
{
   char Name[64];
   char Background[1024];
   int  Sex,Race,Profession,Age;
   int Stat[NOSTATS];
};

struct chars
{
   char Name[64];
};

// Variable Declarations

chars Races[4] = {{"Human"}, {"Elf"}, {"Dwarf"}, {"Halfling"}};
chars Professions[4]={{"Warrior"}, {"Ranger"}, {"Thief"}, {"Academic"}};
chars StatNames[NOSTATS] = {{"HS"}, {"RS"}, {"S "}, {"T "}, {"HR"}};

// Funtion Declarations

void introtext();
void randomize(char * Word);
character chargen();
void getbackground(char * To,character PC);
int getlistresponse(chars List[],int N);
character displaypcinfo(character PC,int What);
int roll(int X,int Y,int Z);

// main

void main()
{
   introtext();

   character Player;
   Player=chargen();
   displaypcinfo(Player,7);
}

void introtext()
{
   printf("     Adventurer!\n");
   printf("        v0.01\n");
   printf("        alpha\n\n");

   printf("       (c)1997\n");
   printf("     Mark Harman\n\n");
}

void randomize(char * Word)
{
   // a feeble attempt to 'randomize' the rand() function
   // by calling rand() a number of times dependant on the PC's name
   for(int k=0;k<*Word;k++)
      rand();
}

character chargen()
{
   // generates a PC according to struct character

   struct character PC;
   printf("Character Generation...\n\n");

   printf("Please a name for your character (One Word Only!) :\n");
   scanf("%s",&PC.Name);
   randomize(PC.Name);

   printf("Please select a Race:\n");
   PC.Race=getlistresponse(Races,4);

   printf("Please select a Profession:\n");
   PC.Profession=getlistresponse(Professions,4);

   // main stats
   switch(PC.Race)
   {
      case 0 :
         // Human
         PC.Age=roll(2,8,18);
         PC.Stat[0]=roll(2,10,20);
         PC.Stat[1]=roll(2,10,20);
         PC.Stat[2]=roll(2,10,20);
         PC.Stat[3]=roll(2,10,20);
         PC.Stat[4]=roll(6,10,180);
         break;
      case 1 :
         // Elf
         PC.Age=roll(4,10,180);
         PC.Stat[0]=roll(2,10,20);
         PC.Stat[1]=roll(2,10,30);
         PC.Stat[2]=roll(2,10,10);
         PC.Stat[3]=roll(2,10,15);
         PC.Stat[4]=roll(6,10,140);
         break;
      case 2 :
         // Dwarf
         PC.Age=roll(2,10,90);
         PC.Stat[0]=roll(2,10,30);
         PC.Stat[1]=roll(2,10,10);
         PC.Stat[2]=roll(2,10,25);
         PC.Stat[3]=roll(2,10,30);
         PC.Stat[4]=roll(6,10,220);
         break;
      case 3 :
         // Halfling
         PC.Age=roll(2,8,60);
         PC.Stat[0]=roll(2,10,20);
         PC.Stat[1]=roll(2,10,20);
         PC.Stat[2]=roll(2,10,15);
         PC.Stat[3]=roll(2,10,15);
         PC.Stat[4]=roll(6,10,160);
         break;
   }

   getbackground(PC.Background,PC);

   return PC;
}

void getbackground(char * To,character PC)
{
   char Background[]="You had a nice childhood...\n  After many years, you decide to set out and explore the dangerous lands.\n";
   strcpy(To,Background);
}

int getlistresponse(chars List[],int N)
{
   // gets a response from a list displayed
   int k,Response;
   for(k=0;k<N;k++)
      printf(" %d - %s,\n",k,List[k].Name);

   printf(">");
   scanf("%d",&Response);
   return Response; 
}

character displaypcinfo(character PC,int What)
{
   // simple status screen
   // What(bits): 1=main, 2=background, 3=equipment
   if((What && 1)==1)
   {
      printf("Name       : %s\n",PC.Name);
      printf("Race       : %s\n",Races[PC.Race].Name);
      printf("Profession : %s\n",Professions[PC.Profession].Name);
      printf("Age        : %d\n",PC.Age);
      for(int k=0;k<NOSTATS;k++)
         printf("%s         : %d\n",StatNames[k].Name,PC.Stat[k]);
      printf("\n");
   }
   if((What && 2)==1)
   {
      printf("Background:\n");
      printf("%s",PC.Background);
      printf("\n");
   }
}

int roll(int X,int Y,int Z)
{
   // Roll X DY+Z
   int val=0,tval;
   for(int k=0;k<X;k++)
   {
      tval=rand() % Y;
      val+=tval+1;
   }
   val+=Z;
   return(val);
}
