
#include<stdio.h>
#include<stdlib.h>


int main() {

  int a = 6;
  int * b = & a;
  printf("%x %d\n", b, * b);

  int * c = & a;

  *b = 7;

  printf("%x %d\n", b, * b);
}
