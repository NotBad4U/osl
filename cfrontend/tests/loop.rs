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
    }
    "###;

    let expected_osl_program = r###"
fn main() -> #voidTy {
    decl a;
    transfer newResource(copy,mut) a;
    read(a);
    !{
        call printf2(newResource(),a);
        transfer newResource(copy,mut) a;
        read(a);
    };
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
    }
    "###;

    let expected_osl_program = r###"
fn main() -> #voidTy {
    decl a;
    transfer newResource(copy,mut) a;
    !{
        call printf2(newResource(),a);
        transfer newResource(copy,mut) a;
        read(a);
    };
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
    decl i;
    transfer newResource(copy,mut) i;
    read(i);
    !{
        call printf2(newResource(), i);
        transfer newResource(copy,mut) i;
        read(i);
    };
};

call main();
"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
#[ignore]
fn it_should_transpile_for_loop_with_multiple_expressions() {
    let c_program = r###"
    void main () {
        int i, j;     
        for(i = 0, j = 0; i < 20; i++, j++){
        }
    }
    "###;

    let expected_osl_program = r###"
fn main() -> #voidTy {
    decl i;
    decl j;
    transfer newResource(copy,mut) i;
    transfer newResource(copy,mut) j;
    read(i);
    !{
        transfer newResource(copy,mut) i;
        transfer newResource(copy,mut) j;
        read(i);
    };
};

call main();
"###;

    assert_equal_program(c_program, expected_osl_program);
}
