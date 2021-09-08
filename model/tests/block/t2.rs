
decl x;
decl y1;
decl y2;

transfer newResource() x;

y1 mborrow x;

y2 borrow x;

unsafe {
    read(y1);
};

decl z;