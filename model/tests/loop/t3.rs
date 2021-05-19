

decl x ;

transfer newResource() x;
decl y;

transfer newResource() y;

decl z;
! {
  @ {z borrow x;}, {z borrow y ;} ;
} ;

decl z1;
z1 mborrow x ;


read(z);