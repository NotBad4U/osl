
/*
 recursive function

fn fibonacci(n: u32) -> u32 {
    match n {
        0 => 1,
        1 => 1,
        _ => fibonacci(n - 1) + fibonacci(n - 2),
    }
}

*/


fn fibonacci(n: #own(copy)) -> #own(copy) {
   decl tmp;
   read(n);
   @ {}, {}, { n; n;};
} ;

decl n1;
transfer newResource(copy) n1;

call fibonacci(n1);
