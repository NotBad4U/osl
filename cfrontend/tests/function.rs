mod common;

use common::assert_equal_program;

#[test]
fn the_lifetime_of_the_one_input_parameter_gets_assigned_to_the_output_lifetime() {
    let c_program = r###"
    int * foo(int * x) {
        return x;
    }

    void main() {}
    "###;

    let expected_osl_program = r###"
fn foo(x:#ref('a,#own(mut))) -> #ref('a,#own(mut)) {
    x
}

fn main() -> #voidTy {
}

call main();
"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn each_parameter_gets_its_own_lifetime() {
    let c_program = r###"
    int * foo(int * x, int * y, int * z) {}

    void main() {}
    "###;

    let expected_osl_program = r###"
fn foo(x:#ref('a,#own(mut)),y:#ref('b,#own(mut)),z:#ref('c,#own(mut))) -> #ref('rt,#own(mut)) {
}

fn main() ->  #voidTy {
}

call main();
"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_find_the_mutability_of_the_return_type() {
    let c_program = r###"
    int mutable() {}
    const int immutable() {}
    int * mutable_ref() {}
    const int * immutable_ref() {}

    void main() {}
    "###;

    let expected_osl_program = r###"
fn mutable() -> #own(mut) {
}

fn immutable() -> #own() {
}

fn mutable_ref() -> #ref('rt,#own(mut)) {
}

fn immutable_ref() -> #ref('rt,#own(mut)) {
}

fn main() ->  #voidTy {
}
call main();
"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_void_type_to_voidty() {
    let c_program = r###"
    void main() {}
    "###;

    let expected_osl_program = r###"
fn main() -> #voidTy {
}
call main();
"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_adress_argument() {
    let c_program = r###"
    void foo(int * a, int b) {

    }

    void main() {
        int a, b;
        foo(&a, b);
    }
    "###;

    let expected_osl_program = r###"
fn foo(a:#ref('a,#own(mut)),b:#own(mut)) -> #voidTy {
}

fn main() -> #voidTy {
    decl a;
    decl b;
    call foo(a,b);
}
call main();
"###;

    assert_equal_program(c_program, expected_osl_program);
}
