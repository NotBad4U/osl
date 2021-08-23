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
fn foo(x:#own(mut)) -> #voidTy {};

fn main() -> #voidTy {
call foo(x);
};
call main();
"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_deref() {
    let c_program = r###"
    void main() {
        int a, b;
        int *p;
        p = &a;
        b = *p;
    }
    "###;

    let expected_osl_program = r###"
fn main() -> #voidTy {
    decl a;
    decl b;
    decl p;
    p mborrow a;
    transfer *p b;
};
call main();
"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_assign_constant() {
    let c_program = r###"
    void main() {
        int a;
        a = 5;
    }
    "###;

    let expected_osl_program = r###"
fn main() -> #voidTy {
    decl a;
    transfer newResource(copy, mut) a;
};
call main();
"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_semantic_move() {
    let c_program = r###"
    void main() {
        int a, b;
        a = b;
    }
    "###;

    let expected_osl_program = r###"
fn main() -> #voidTy {
    decl a;
    decl b;
    transfer a b;
};
call main();
"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_assign() {
    let c_program = r###"
    void main() {
        int a, b, c;
        a = a + b + (1 - c);
    }
    "###;

    let expected_osl_program = r###"
fn main() -> #voidTy {
    decl a;
    decl b;
    decl c;
    read(a);
    read(b);
    read(c);
    transfer newResource(copy,mut) a;
};
call main();
"###;

    assert_equal_program(c_program, expected_osl_program);
}
