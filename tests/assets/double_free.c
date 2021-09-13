#include <stdio.h>
#include <unistd.h>

#define BUFSIZE1    512
#define BUFSIZE2    ((BUFSIZE1/2) - 8)

int main() {
  char *buf1R1;

  buf1R1 = (char *) malloc(BUFSIZE2);

  free(buf1R1);
  free(buf1R1);

}