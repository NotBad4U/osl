int main()
{
    int base, exp;
    long double result = 1.0;
    printf("Enter a base number: ");
    scanf("%d", &base);
    printf("Enter an exponent: ");
    scanf("%d", &exp);

    while (exp != 0)
    {
        result *= base;
        --exp;
    }
    printf("Answer = %.0Lf", result);
    return 0;
}

int main2()
{
    int n;
    printf("Enter an integer: ");
    scanf("%d", &n);
    for (int i = 1; i <= 10; ++i)
    {
        printf("%d * %d = %d \n", n, i, n * i);
    }
    return 0;
}

int main()
{
    for (;;)
    {
        printf("Hello javatpoint");
    }
    return 0;
}

int main()
{
    int i = 0;
    while (1)
    {
        i++;
        printf("i is :%d", i);
    }
    return 0;
}