

fn foo(v1: #ref('a, #own()), v2: #ref('a, #own())) -> #own(copy) {
   val(newResource(copy))
}

decl v1;
transfer newResource() v1;
decl v2;
transfer newResource() v2;

decl a1;
a1 borrow v1;
decl a2;
a2 borrow v2;


call foo(v1,v2) ;