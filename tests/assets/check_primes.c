#include <stdio.h>
int checkPrimeNumber(int n);

// user-defined function to check prime number
int checkPrimeNumber(int n) {
    int j, flag = 1;
    for (j = 2; (j <= n / 2)  && (n % j == 0); ++j) {
        if (n % j == 0) {
            flag = 0;
        }
    }
    return flag;
}

int main() {
    int n1, n2, i, flag;
    printf("Enter two positive integers: ");
    n1 = 1;
    n2 = 21;

    //printf("Prime numbers between %d and %d are: ", n1, n2);

    for (i = n1 + 1; i < n2; ++i) {
        // flag will be equal to 1 if i is prime
        flag = checkPrimeNumber(i);

        if (flag == 1)
            printf("%d ", i);
    }
    return 0;
}

