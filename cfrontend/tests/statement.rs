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
}
call main();
"###;

    assert_equal_program(c_program, expected_osl_program);
}


#[test]
#[should_panic]
fn it_should_not_support_goto() {
    let c_program = r###"
    void main() {
        loop:
        goto loop;
    }
    "###;

    let expected_osl_program = r###"
fn main() -> #voidTy {
}
call main();
"###;

    assert_equal_program(c_program, expected_osl_program);
}
