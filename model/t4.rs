

/*
fn sumV(v:&Vec<i32>,i:usize) -> i32 {
    if (i >= v.len()) { 0 }
    else {v[i] + sumV(v,i+1)}
}
*/

fn sumV(v: #ref('a, #own()), i:#own(copy)) -> #own(copy) {

   //The condition i >= v.len()
   //needs to read both v and i
   read(i);
   read(v);
   @ {
      val(newResource(copy))  //This returns the value 0
   }, {
      read(v) ; //corresponds to read v[i];
      //the recursive call to sumV(v,i+1)
      //vt and it are two variables for inputing to the recursive call
      decl vt ;
      transfer v vt;
      read(i);
      decl it;
      read(i);
      transfer newResource(copy) it;
      //Finishing passing arguments, But we do not call sumV again.
      //The reason why we do not need to
      //call sumV again because sumV has no effect to
      //v and i after calling it, with respect to ownership.
      val(newResource(copy))  //return a copyable resource
   } ;
};


decl vi;
transfer newResource() vi;

decl ii;
transfer newResource(copy) ii;

decl vii;

vii borrow vi;

call sumV(vii, ii);

