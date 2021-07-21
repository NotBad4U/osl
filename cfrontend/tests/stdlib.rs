mod common;

#[test]
fn it_should_transpile_stdlibs() {
    let expected_osl_program = common::format_source(
        r###"
        decl stdin;
        decl stdout;
        decl stderr;
        decl sys_nerr;
        decl sys_errlist;

        fn __bswap_16(__bsx:#own(mut)) -> #own(mut) {
            val(newResource(mut))
        }
        
        fn __bswap_32(__bsx:#own(mut)) -> #own(mut) {
            val(newResource(mut))
        }
        
        fn __bswap_64(__bsx:#own(mut)) -> #own(mut) {
            val(newResource(mut))
        }
        
        fn __uint16_identity(__x:#own(mut)) -> #own(mut) {
            val(newResource(mut))
        }
        
        fn __uint32_identity(__x:#own(mut)) -> #own(mut) {
            val(newResource(mut))
        }
        
        fn __uint64_identity(__x:#own(mut)) -> #own(mut) {
            val(newResource(mut))
        }
        
        call main();    
        "###
        .to_string(),
    );

    let osl_program =
        common::render_and_format(common::transpile_c_program("tests/assets/stdlib.c"));

    assert!(osl_program == expected_osl_program)
}
