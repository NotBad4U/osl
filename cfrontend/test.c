int a;
int a = 10;
const int * a = 10, b = 10;

const int * a;
int * const a; 
const int * const a = 4;

enum truth { a = 4, b = 5 };

enum { ONE = 1, TWO } e;

enum color { RED, GREEN, BLUE} r = RED;

int max(int num1, int num2) {
   int result;
 
   if (num1 > num2) {
      result = num1;
   }
   else {
      result = num2;
   }

   return result; 
}

struct MaStructure {
    int Age;
    char Sexe;
    char Nom[12];
    float MoyenneScolaire;
    struct AutreStructure StructBis;
};

char *strcpy(char * dest, const char * src);

char *strcpy(char * dest, const char * src) {

    struct car { char *make; char *model; int year; };

    struct car c = {.year=1923, .make="Nash", .model="48 Sports Touring Car"};

    char src[50], dest[50];
    char * bk = dest;
    int sum;
    int count = 5;

    src = "ndzandaz";
    dest[10] = "dzadazda";

    while (*src != 0) {
        *dest++ = *src++;
    }

    *dest = *src;
    return bk;
}