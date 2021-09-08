mod common;

use common::assert_equal_program;

#[test]
fn it_should_ignore_inline_assembly() {
    let c_program = r###"
    void main() {
        __asm__ (
            "movl $10, %eax;"
            "movl $20, %ebx;"
            "addl %ebx, %eax;"
        );
    }
    "###;

    let expected_osl_program = r###"
fn main() -> #voidTy {
};
call main();
"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
#[should_panic]
fn it_should_not_support_goto() {
    let c_program = r###"
    void main() {
        goto loop;
    }
    "###;

    let expected_osl_program = r###"
fn main() -> #voidTy {
};
call main();
"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_return() {
    let c_program = r###"
    int main() {
        int a, b;
        return a;
    }
    "###;

    let expected_osl_program = r###"
fn main() -> #own(copy,mut) {
    decl a;
    decl b;
    a
};
call main();
"###;

    assert_equal_program(c_program, expected_osl_program);
}


#[test]
fn it_should_transpile_unsafe_block() {
    let c_program = r###"
    void main() {
        unsafe: {
            int a;
        };
        UNSAFE: {
            int a;
        };
        int b;
    }
    "###;

    let expected_osl_program = r###"
fn main() -> #voidTy {
    unsafe{
        decl a;
    };
    unsafe{
        decl a;
    };
    decl b;
};
call main();
"###;

    assert_equal_program(c_program, expected_osl_program);
}