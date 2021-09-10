//decl x;
//decl y1;
//decl y2;
//
//transfer newResource() x;
//
//
//
//y2 borrow x;  but al
//
//read(y1);

#include <stdio.h>

int main()
{
    int x = 45;
    const int *y1 = &x; // y1 borrow x;
    int *y2 = &x; // y2 mborrow x;
    printf("%d", y1);  // read(y1) but y2 mborrow x
    return 0;
}