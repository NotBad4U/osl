
decl x1;
decl x2;
decl x3;

transfer newResource() x1;
transfer newResource(copy) x2;
transfer newResource() x3;

decl b1;
decl b2;
decl b3;

b1 borrow x1;
b2 borrow b1;
b3 borrow b2;

read(b3);

decl z;

//transfer *b2 z; // this statement is illegal, since we try to move a borrowed content

decl z1;

transfer x3 z1;