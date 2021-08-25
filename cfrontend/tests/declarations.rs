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

    let expected_osl_program = r###"
fn main() -> #voidTy {
decl a;
transfer newResource(mut,copy) a;
};
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

    let expected_osl_program = r###"fn main() -> #voidTy {
decl a;
transfer newResource(mut,copy) a;
decl b;
b mborrow a;
};
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

    let expected_osl_program = r###"
fn main() -> #voidTy {
decl a;
transfer newResource(copy) a;
decl b;
b borrow a;
};
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

    let expected_osl_program = r###"
fn main() -> #voidTy {
decl a;
decl b;
b mborrow a;
decl c;
c borrow a;
};
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
fn main() -> #voidTy {
decl a;
transfer newResource(mut,copy) a;
decl b;
transfer newResource(copy) b;
};
call main();"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_declaration_of_array() {
    let c_program = r###" 
        void main () {
            double a[5];
            double b[];
            double c[3] = {1.0, 1.0, 1.0};
        }
    "###;

    let expected_osl_program = r###"
fn main() -> #voidTy {
    decl a;
    decl b;
    decl c;
    transfer newResource(mut) c;
};
call main();"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_declaration_of_structure_type() {
    let c_program = r###" 
    struct complex
    {
        int imag;
        float real;
    };
    "###;

    let expected_osl_program = r###"
call main();"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_declaration_of_structure_variable() {
    let c_program = r###" 
    struct complex
    {
        int imag;
        float real;
    } p1, p2;
    "###;

    let expected_osl_program = r###"
decl p1;
decl p2;
call main();"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_declaration_of_structure_variable_with_init() {
    let c_program = r###" 
    struct complex
    {
        int imag;
        float real;
    };

    void main() {
        struct complex c1, c2 = { .imag = 1, .real = 1.0 }, c3;
    }
    "###;

    let expected_osl_program = r###"
fn main() -> #voidTy {
    decl c1;
    decl c2;
    transfer newResource() c2;
    decl c3;
};

call main();"###;

    assert_equal_program(c_program, expected_osl_program);
}
