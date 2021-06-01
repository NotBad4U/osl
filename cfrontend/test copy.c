 int max(int num1, int num2);

 char *strcpy(char *dest, const char *src);

 
struct Books {
   char  title[50]
   char  author[50]
   char  subject[100]
   const int *  book_id
} book;

typedef struct Books {
   char title[50];
   char author[50];
   char subject[100]
   int book_id
} Book;

enum fruits{  
    mango=2,  
    apple=1,
    strawberry=5,
    papaya=7
}; 

enum fruits{mango, apple, strawberry, papaya};  

union employee  
{
    int id  
    char name[50]  
    float salary  
};  

int main () {
    char * const array;

    const int * d;

    int * const pi;
    *pi = 200;

    int i = 100;
    const int * const pi = &i;

    int a = 100;
    int b = 200;
    int ret;

    a = a + b;

    call(a,b);

    return 0;
}
 
int max(int num1, int num2) {
   int result;
 
   if (num1 == num2)
      result = num1;
   else
      result = num2;
 
   return result; 
}

char *strcpy(char * dest, const char * src) {
    char * bk = dest;

    while (*src != 0) {
        *dest++ = *src++;
    }

    *dest = *src;
    return bk;
}