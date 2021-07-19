mod common;

#[test]
fn it_should_transpile_simple_type_declarations() {
    let c_program = r###"
    int a;
    float b;
    double c;
    long double d;
    unsigned long long int e;
    "###
    .to_string();

    let expected_osl_program = common::format_source(
        r###"decl a;
    decl b;
    decl c;
    decl d;
    decl e;
    call main();
    "###
        .to_string(),
    );

    let osl_program = common::render_and_format(common::transpile_c_program(c_program));

    assert_eq!(osl_program, expected_osl_program)
}

#[test]
fn it_should_transpile_simple_pointers_declarations() {
    let c_program = r###"
    int * a;
    float * b;
    double * c;
    long double * d;
    unsigned long long int * e;
    "###
    .to_string();

    let expected_osl_program = common::format_source(
        r###"decl a;
    decl b;
    decl c;
    decl d;
    decl e;
    call main();
    "###
        .to_string(),
    );

    let osl_program = common::render_and_format(common::transpile_c_program(c_program));

    assert_eq!(osl_program, expected_osl_program)
}

#[test]
fn it_should_transpile_simple_const_declarations() {
    let c_program = r###"
    const int a;
    const float b;
    const double c;
    const long double d;
    const unsigned long long int e;
    "###
    .to_string();

    let expected_osl_program = common::format_source(
        r###"decl a;
    decl b;
    decl c;
    decl d;
    decl e;
    call main();
    "###
        .to_string(),
    );

    let osl_program = common::render_and_format(common::transpile_c_program(c_program));

    assert_eq!(osl_program, expected_osl_program)
}

#[test]
fn it_should_transpile_simple_pointer_to_const_declarations() {
    let c_program = r###"
    const int * a;
    const float * b;
    const double * c;
    const long double * d;
    const unsigned long long int e;
    "###
    .to_string();

    let expected_osl_program = common::format_source(
        r###"decl a;
    decl b;
    decl c;
    decl d;
    decl e;
    call main();
    "###
        .to_string(),
    );

    let osl_program = common::render_and_format(common::transpile_c_program(c_program));

    assert_eq!(osl_program, expected_osl_program)
}
