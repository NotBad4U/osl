// convert binary to decimal

#include <stdio.h>
#include <math.h>

// function prototype
int convert(long long);

// function definition
int convert(long long __n) {
  int dec = 0, i = 0, rem;

  while (__n!=0) {
    rem = __n % 10;
    __n /= 10;
    dec += rem * pow(2, i);
    ++i;
  }

  return dec;
}

int main() {
  long long n;
  printf("Enter a binary number: ");
  //scanf("%lld", &n);
  n = 1101;
  int dec = convert(n);
  return 0;
}

