#include <stdio.h>
main()
{
  int vrh=1000, dno=0, i=1;
  char c,s[10];
   
  printf("\fZamisli jedan broj izmeðu 0 i %d, a ja æu ga pogoditi iz najvi¹e deset \npoku¹aja.\n",vrh);
  printf("Odgovaraj sa veæi, manji ili toèno (i nemoj lagati).\n\n\n");
  do
  {
     printf("Jel' to mo¾da broj %d ?", (vrh+dno)/2); 
     scanf("%s",s);
     c=s[0];
     if(c=='m' || c=='M')
     {
        vrh=(vrh+dno)/2-1; 
        i++;
     }
     else if(c=='v' || c=='V')
     {  
         dno=(vrh+dno)/2+1;
         i++;
     }
     else if(c!='t' && c!='T')
        printf("Molim?\n");
   
  }
  while (c!='t' && c!='T');
  
  printf("URA!!! \nPogodio sam iz samo %d puta!!!\n",i);

}
