mod common;
use common::assert_equal_program_from_file;

#[test]
fn it_should_transpile_stdlibs() {
    let expected_osl_program = r###"    
decl stdin;
decl stdout;
decl stderr;
decl sys_nerr;
decl sys_errlist;
fn __bswap_16(__bsx:#own(mut)) -> #own(mut) {
    call __builtin_bswap16(__bsx);
}

fn __bswap_32(__bsx:#own(mut)) -> #own(mut) {
    call __builtin_bswap32(__bsx);
}

fn __bswap_64(__bsx:#own(mut)) -> #own(mut) {
    call __builtin_bswap64(__bsx);
}

fn __uint16_identity(__x:#own(mut)) -> #own(mut) {
    __x;
}

fn __uint32_identity(__x:#own(mut)) -> #own(mut) {
    __x;
}

fn __uint64_identity(__x:#own(mut)) -> #own(mut) {
    __x;
}

call main();
"###;

    assert_equal_program_from_file("tests/assets/stdlib.c", expected_osl_program);
}
