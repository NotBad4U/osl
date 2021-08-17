mod common;
use common::assert_equal_program;

#[test]
fn it_should_transpile_if_else_statement() {
    let c_program = r###"
    void main() {
        int age = 23;
        int limit = 30;
        int ok;

        if (age >= limit) {
            ok = 0;
        }
        else {
            ok = 1;
        }
    }
    "###;

    let expected_osl_program = r###"
        fn main() ->  #voidTy {
            decl age;
            transfer newResource(mut,copy) age;
            decl limit;
            transfer newResource(mut,copy) limit;
            decl ok;
            read(age);
            read(limit);
            @
            {
                transfer newResource(copy,mut) ok;
            },
            {
                transfer newResource(copy,mut) ok;
            }
        }
        call main();
    "###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_if_statement_and_ignore_constant() {
    let c_program = r###"
    void main() {
        int age = 23;
        int ok;

        if (age >= 30) {
            ok = 0;
        }
        else {
            ok = 1;
        }
    }
    "###;

    let expected_osl_program = r###"
        fn main() ->  #voidTy {
            decl age;
            transfer newResource(mut,copy) age;
            decl ok;
            read(age);
            @
            {
                transfer newResource(copy,mut) ok;
            },
            {
                transfer newResource(copy,mut) ok;
            }
        }
        call main();
    "###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_nested_if_else_statements() {
    let c_program = r###"
    void main() {
        int x;

        if (x) {
            if (x) {} else {}
        }
        else {
            if (x) {} else {}
        }
    }
    "###;

    // Note that the transpiler ignore empty else condition
    let expected_osl_program = r###"
    fn main() ->  #voidTy {
        decl x;
        read(x);
        @{
            read(x);
            @{
            }
        },{
            read(x);
            @{
            }
        }
    }
    call main();
    "###;

    assert_equal_program(c_program, expected_osl_program);
}
