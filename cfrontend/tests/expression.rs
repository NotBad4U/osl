mod common;

use common::assert_equal_program;

#[test]
fn it_should_transpile_call_expression() {
    let c_program = r###"
    void foo(int x) {
    }

    void main() {
        foo(x);
    }
    "###;

    let expected_osl_program = r###"
fn foo(x:#own(mut)) -> #own(mut) {}

fn main() -> #own(mut) {
call foo(x);
}
call main();
"###;

    assert_equal_program(c_program, expected_osl_program);
}


#[test]
#[ignore]
fn it_should_transpile_deref() {
    let c_program = r###"
    void main() {
        int a = 7, b ;
        int *p; // Un-initialized Pointer
        p = &a; // Stores address of a in ptr
        b = *p; // Put Value at ptr in b
    }
    "###;

    let expected_osl_program = r###"
fn main() -> #own(mut) {
    decl a;
    transfer newResource() a;
    decl b;
    decl p;
    p mborrow a;
    transfer *p  b;    
}
call main();
"###;

    assert_equal_program(c_program, expected_osl_program);
}