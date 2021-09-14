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
    transfer b a;
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

#[test]
fn it_should_transpile_assign_array() {
    let c_program = r###"
    void main() {
        int a[10];
        a[0] = 1;
    }
    "###;

    let expected_osl_program = r###"
fn main() -> #voidTy {
    decl a;
    transfer newResource(mut) a;
};
call main();
"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_passing_array_as_args() {
    let c_program = r###"
    void main() {
        int a[10];
        printf("%d", a[0]);
        printf("%d", &a[0]);
    }
    "###;

    let expected_osl_program = r###"
fn main() -> #voidTy {
    decl a;
    call printf2(newResource(), a);
    call printf2(newResource(), a);
};
call main();
"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_passing_struct_as_args() {
    let c_program = r###"
    struct foo {
        int x;
    };
    
    void main() {
        struct foo f;
        printf("%d", f.x);
    }
    "###;

    let expected_osl_program = r###"
fn main() -> #voidTy {
    decl f;
    call printf2(newResource(), f);
};
call main();
"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_matrice_id() {
    let c_program = r###"
    void main() {
        int a[10];
        a[10];
    }
    "###;

    let expected_osl_program = r###"
fn main() -> #voidTy {
    decl a;
    a;
}; 
call main();
"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_matrice_assign_between_matrice() {
    let c_program = r###"
    void main() {
        int a[10][10];
        int b[10][10];
        int c[10][10];
        a[0][0] = b[4][7] + c[9][9];
    }
    "###;

    let expected_osl_program = r###"
fn main() -> #voidTy {
    decl a;
    decl b;
    decl c;
    read(b);
    read(c);
    transfer newResource() a;
}; 
call main();
"###;

    assert_equal_program(c_program, expected_osl_program);
}
