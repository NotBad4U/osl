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

int main()
{       
    int x = 45;
    const int *y1 = &x;
    int *y2 = &x;
    UNSAFE:
    {
        y1;
    };

    return 0;
};