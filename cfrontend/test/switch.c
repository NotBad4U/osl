int main()
{
        int x = 2;
        switch (x)
        {
        case 1:
                printf("Choice is 1");
                break;
        case 2:
                printf("Choice is 2");
                break;
        case 3:
                printf("Choice is 3");
                break;
        default:
                printf("Choice other than 1, 2 and 3");
                break;
        }
        return 0;
}

// int main() {
//     char operator;
//     double n1, n2;

//     printf("Enter an operator (+, -, *, /): ");
//     scanf("%c", &operator);
//     printf("Enter two operands: ");
//     scanf("%lf %lf",&n1, &n2);

//     switch(operator)
//     {
//         case '+':
//             printf("%.1lf + %.1lf = %.1lf",n1, n2, n1+n2);
//             break;

//         case '-':
//             printf("%.1lf - %.1lf = %.1lf",n1, n2, n1-n2);
//             break;

//         case '*':
//             printf("%.1lf * %.1lf = %.1lf",n1, n2, n1*n2);
//             break;

//         case '/':
//             printf("%.1lf / %.1lf = %.1lf",n1, n2, n1/n2);
//             break;

//         // operator doesn't match any case constant +, -, *, /
//         default:
//             printf("Error! operator is not correct");
//     }

//     return 0;
// }