// convert decimal to binary

#include <stdio.h>
#include <math.h>

long long convert(int);

long long convert(int __n) {
  long long bin = 0;
  int rem, i = 1;

  while (__n != 0) {
    rem = __n % 2;
    __n /= 2;
    bin += rem * i;
    i *= 10;
  }

  return bin;
}

int main() {
    int n, bin;
    printf("Enter a decimal number: ");
    n = 10;
    bin = convert(n);
    //printf("%d in decimal =  %lld in binary", n, bin);
    return 0;
}
