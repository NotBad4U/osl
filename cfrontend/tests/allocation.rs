mod common;

#[test]
fn it_should_transpile_dynamic_memory_allocation() {
    let c_program = r###"
    void main() {
        int* ptr;
        ptr = (int*) calloc(n, sizeof(int));
        ptr = (int*) malloc(n * sizeof(int));
        ptr = (int*) realloc(ptr, n * sizeof(int));
    }
    "###
    .to_string();

    let expected_osl_program = common::format_source(
        r###"
    fn main() -> #own(mut) {
        decl ptr;
        transfer newResource() ptr;
        transfer newResource() ptr;
        transfer newResource() ptr;
    }
    call main();
    "###
        .to_string(),
    );

    let osl_program =
        common::render_and_format(common::transpile_preprocessed_c_program(c_program));

    assert_eq!(osl_program, expected_osl_program)
}
