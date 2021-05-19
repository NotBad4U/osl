

fn f(fx:#own(),fy:#ref('a,#own())) -> #own() {
   decl z;
   z borrow fx;
   decl z1;
   z1 mborrow fx;
   z ;
};

decl x;
transfer newResource() x;

decl y;
transfer newResource() y;

decl y1;

y1 borrow y;

call f(x,y1) ;
