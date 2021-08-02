use lang_c::driver::{parse, parse_preprocessed, Config};
use osl::{ast, configuration::Configuration};

pub fn transpile_preprocessed_c_program(c_program: String) -> ast::Stmts {
    let config = Config::default();
    let ast = parse_preprocessed(&config, c_program.clone()).unwrap();
    osl::transpile_c_program(ast, Configuration::new(false))
}

pub fn transpile_c_program(path: &str) -> ast::Stmts {
    let config = Config::default();
    let ast = parse(&config, path).unwrap();
    osl::transpile_c_program(ast, Configuration::new(false))
}

pub fn render_and_format(program: ast::Stmts) -> String {
    format!("{}", program).replace("\n", "").replace("    ", "")
}

pub fn format_source(program: String) -> String {
    program.replace("\n", "").replace("    ", "")
}
