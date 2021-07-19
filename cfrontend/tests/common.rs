use lang_c::driver::{parse_preprocessed, Config};
use osl::ast;

pub fn transpile_c_program(c_program: String) -> ast::Stmts {
    let config = Config::default();
    let ast = parse_preprocessed(&config, c_program.clone()).unwrap();
    osl::transpile_c_program(ast)
}

pub fn render_and_format(program: ast::Stmts) -> String {
    format!("{}", program).replace("\n", "").replace("    ", "")
}

pub fn format_source(program: String) -> String {
    program.replace("\n", "").replace("    ", "")
}
