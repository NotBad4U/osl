mod common;

use common::assert_equal_program;

#[test]
fn it_should_transpile_simple_type_declarations() {
    let c_program = r###"
    int a;
    float b;
    double c;
    long double d;
    unsigned long long int e;
    "###;

    let expected_osl_program = r###"
decl a;
decl b;
decl c;
decl d;
decl e;
call main();"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_simple_pointers_declarations() {
    let c_program = r###"
    int * a;
    float * b;
    double * c;
    long double * d;
    unsigned long long int * e;
    "###;

    let expected_osl_program = r###"decl a;
decl b;
decl c;
decl d;
decl e;
call main();"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_simple_const_declarations() {
    let c_program = r###"
    const int a;
    const float b;
    const double c;
    const long double d;
    const unsigned long long int e;
    "###;

    let expected_osl_program = r###"decl a;
decl b;
decl c;
decl d;
decl e;
call main();"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_simple_pointer_to_const_declarations() {
    let c_program = r###"
    const int * a;
    const float * b;
    const double * c;
    const long double * d;
    const unsigned long long int e;
    "###;

    let expected_osl_program = r###"decl a;
decl b;
decl c;
decl d;
decl e;
call main();"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_simple_type_declaration_with_an_init() {
    let c_program = r###"
        void main() {
            int a = 5;
        }
    "###;

    let expected_osl_program = r###"fn main() -> #own(mut) {
decl a;
transfer newResource(mut,copy) a;
}
call main();"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_simple_type_mut_borrow_declaration_with_an_init() {
    let c_program = r###"
        void main() {
            int a = 5;
            int *b = &a;
        }
    "###;

    let expected_osl_program = r###"fn main() -> #own(mut) {
decl a;
transfer newResource(mut,copy) a;
decl b;
b mborrow a;
}
call main();"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_simple_type_borrow_declaration_with_an_init() {
    let c_program = r###"
        void main() {
            const int a = 5;
            const int *b = &a;
        }
    "###;

    let expected_osl_program = r###"fn main() -> #own(mut) {
decl a;
transfer newResource(copy) a;
decl b;
b borrow a;
}
call main();"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_const_pointer() {
    let c_program = r###"
        void main() {
            int a;
            int * const b = &a;
            const int * const c = &a;
        }
    "###;

    let expected_osl_program = r###"fn main() -> #own(mut) {
decl a;
decl b;
b mborrow a;
decl c;
c borrow a;
}
call main();"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_declaration_with_init() {
    let c_program = r###"
        void main() {
            int a = 0;
            const int b = 0;
        }
    "###;

    let expected_osl_program = r###"
fn main() -> #own(mut) {
decl a;
transfer newResource(mut,copy) a;
decl b;
transfer newResource(copy) b;
}
call main();"###;

    assert_equal_program(c_program, expected_osl_program);
}
