mod common;

use common::assert_equal_program;

#[test]
fn it_should_transpile_while_loop() {
    let c_program = r###"
    void main () {
        int a = 10;

        while( a < 20 ) {
           printf("value of a: %d\n", a);
           a++;
        }
      
        return 0;
     }
    "###;

    let expected_osl_program = r###"
fn main() -> #voidTy {
    decl a;
    transfer newResource(mut,copy) a;
    read(a);
    !{
        call printf2(newResource(),a);
        transfer newResource(copy,mut) a;
        // loop invariant
        read(a);
    };
    val(newResource(copy))
};

call main();
"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_do_while_loop() {
    let c_program = r###"
    void main () {
        int a = 10;

        do {
            printf("value of a: %d\n", a);
            a++;
        } while( a < 20 );
      
        return 0;
    }
    "###;

    let expected_osl_program = r###"
fn main() -> #voidTy {
    decl a;
    transfer newResource(mut,copy) a;
    !{
        call printf2(newResource(),a);
        transfer newResource(copy,mut) a;
        read(a);
    };
    
    val(newResource(copy))
};

call main();
"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_for_loop() {
    let c_program = r###"
    void main () {     
        for(int i = 10; i < 20; i++ ){
           printf("value of i: %d\n", i);
        }
    }
    "###;

    let expected_osl_program = r###"
fn main() -> #voidTy {
    // loop init
    decl i;
    transfer newResource(mut,copy) i;
    // loop invariant
    read(i);
    !{
        call printf2(newResource(), i);
        transfer newResource(copy,mut) i;
        // loop invariant
        read(i);
    };
};

call main();
"###;

    assert_equal_program(c_program, expected_osl_program);
}
