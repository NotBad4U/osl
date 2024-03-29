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
transfer newResource(copy,mut) a;
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
transfer newResource(copy,mut) a;
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
transfer newResource(copy,mut) a;
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
//FIXME: newResource() has no props.
fn it_should_transpile_declaration_of_matrice() {
    let c_program = r###" 
        void main () {
            int a[5][2] = { {0,0}, {1,2}, {2,4}, {3,6},{4,8}};
            printf("a[1][1] = %d\n", a[1][2][3]);
        }
    "###;

    let expected_osl_program = r###"
fn main() -> #voidTy {
    decl a;
    transfer newResource() a;
    call printf2(newResource(), a);
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
    transfer newResource(copy,mut) c2;
    decl c3;
};

call main();"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_declaration_of_enum_constants() {
    let c_program = r###" 
    enum week{sunday, monday, tuesday, wednesday, thursday, friday, saturday};
    enum day{Mond, Tues, Wedn, Thurs, Frid=18, Satu=11, Sund};
    "###;

    let expected_osl_program = r###"
call main();"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_declaration_of_enum_variable() {
    let c_program = r###" 
    enum {Mon, Tue, Wed, Thur, Fri, Sat, Sun};

    void main() {
        enum week day;
        day = Wed;
    }
    "###;

    let expected_osl_program = r###"
fn main() -> #voidTy {
    decl day;
    transfer newResource(copy) day;
};

call main();"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_declaration_with_calculus_as_initializer() {
    let c_program = r###" 
    void main() {
    double p = 3;
    double q = 7;
    double n=p*q;
    }
    "###;

    let expected_osl_program = r###"
fn main() -> #voidTy {
    decl p;
    transfer newResource(copy,mut) p;
    decl q;
    transfer newResource(copy,mut) q;
    decl n;
    rd(p);
    rd(q);
    transfer newResource(copy,mut) n;
};

call main();"###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_declaration_with_call_function_as_initializer() {
    let c_program = r###" 
    void main() {
    double c = pow(x,y);
    }
    "###;

    let expected_osl_program = r###"
fn main() -> #voidTy {
    decl c;
    transfer call pow(x,y) c; 
};

call main();"###;

    assert_equal_program(c_program, expected_osl_program);
}
