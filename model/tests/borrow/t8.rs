
/*

let x = Box::new(1) ;
let y = & x;

let z = * y;

*/


decl x;
transfer newResource() x;
decl y;
y borrow x;
decl z;
transfer *y  z;