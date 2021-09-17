use cfrontend::{ast, configuration::Configuration};
use lang_c::driver::{parse, parse_preprocessed, Config};

#[allow(dead_code)]
fn transpile_preprocessed_c_program(c_program: String) -> ast::Stmts {
    match parse_preprocessed(&Config::default(), c_program.clone()) {
        Ok(ast) => match cfrontend::transpile_c_program(ast, Configuration::new(false)) {
            Ok(stmts) => stmts,
            Err(e) => panic!("{:#?}", e),
        }
        Err(e) => panic!("{}", e),
    }
}

#[allow(dead_code)]
fn transpile_c_program(path: &str) -> ast::Stmts {
    let ast = parse(&Config::default(), path).unwrap();
    match cfrontend::transpile_c_program(ast, Configuration::new(false)) {
        Ok(stmts) => stmts,
        Err(e) => panic!("{:#?}", e),
    }
}

#[allow(dead_code)]
fn render(program: ast::Stmts) -> String {
    ast::render::render_program(program)
}

#[allow(dead_code)]
fn are_same_programs(p1: &str, p2: &str) -> bool {
    let p1_f: Vec<_> = p1.chars().filter(|c| *c != ' ' && *c != '\n').collect();
    let p2_f: Vec<_> = p2.chars().filter(|c| *c != ' ' && *c != '\n').collect();

    // zip truncate the slice if one is bigger than other one
    if p1_f.len() != p2_f.len() {
        return false;
    }

    p1_f.iter().zip(p2_f.iter()).find(|(x, y)| x != y).is_none()
}

#[allow(dead_code)]
pub fn assert_equal_program(program: &str, expected: &str) {
    let actual = render(transpile_preprocessed_c_program(program.to_string()));

    if !are_same_programs(&actual, expected) {
        let diffs = format!(
            "{}",
            colored_diff::PrettyDifference {
                expected: expected.trim(),
                actual: actual.as_str().trim()
            }
        );
        panic!("{}", diffs);
    }
}

#[allow(dead_code)]
pub fn assert_equal_program_from_file(path: &str, expected: &str) {
    let actual = render(transpile_c_program(path));
    if !are_same_programs(&actual, expected) {
        let diffs = format!(
            "{}",
            colored_diff::PrettyDifference {
                expected: expected.trim(),
                actual: actual.as_str().trim()
            }
        );
        panic!("{}", diffs);
    }
}
