use lang_c::driver::{parse, parse_preprocessed, Config};
use osl::{ast, configuration::Configuration};

#[allow(dead_code)]
fn transpile_preprocessed_c_program(c_program: String) -> ast::Stmts {
    let config = Config::default();
    let ast = parse_preprocessed(&config, c_program.clone()).unwrap();
    osl::transpile_c_program(ast, Configuration::new(false))
}

#[allow(dead_code)]
fn transpile_c_program(path: &str) -> ast::Stmts {
    let config = Config::default();
    let ast = parse(&config, path).unwrap();
    osl::transpile_c_program(ast, Configuration::new(false))
}

#[allow(dead_code)]
fn render(program: ast::Stmts) -> String {
    format!("{}", program)
}

#[allow(dead_code)]
fn are_same_programs(p1: &str, p2: &str) -> bool {
    let p1_f: Vec<_> = p1.chars().filter(|c| *c != ' ' && *c != '\n').collect();
    let p2_f: Vec<_> = p2.chars().filter(|c| *c != ' ' && *c != '\n').collect();

    if p1_f.len() != p2_f.len() {
        return false;
    }

    p1_f.iter().zip(p2_f.iter()).find(|(x, y)| x != y).is_none()
}

#[allow(dead_code)]
pub fn are_equal(program: &str, expected: &str) -> bool {
    let osl_program = render(transpile_preprocessed_c_program(program.to_string()));

    are_same_programs(&osl_program, expected)
}

#[allow(dead_code)]
pub fn are_equal_from_file(path: &str, expected: &str) -> bool {
    let osl_program = render(transpile_c_program(path));

    are_same_programs(&osl_program, expected)
}
