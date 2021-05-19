
#include<stdlib.h>
void main()
 {
   char *ptr = NULL;
   {
       char ch = 'a';
       ptr = &ch;
   }

   printf("%c", *ptr);

}
