mod common;
use common::assert_equal_program;

#[test]
fn it_should_transpile_dynamic_memory_allocation() {
    let c_program = r###"
    void main() {
        int* ptr;
        ptr = (int*) calloc(n, sizeof(int));
        ptr = (int*) malloc(n * sizeof(int));
        ptr = (int*) realloc(ptr, n * sizeof(int));
    }
    "###;

    let expected_osl_program = r###"
fn main() -> #own(mut) {
decl ptr;
transfer newResource() ptr;
transfer newResource() ptr;
transfer newResource() ptr;
}

call main();
"###;

    assert_equal_program(c_program, expected_osl_program);
}
