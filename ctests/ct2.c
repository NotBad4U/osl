
#include<stdio.h>
#include<stdlib.h>

int main()
{
   
   int * x;
   int * * y;
   
   x = (int *) malloc(sizeof(int));
   
   y = & x;
   
    return 0;
}
