#[macro_use]
extern crate log;

use lang_c::driver::Config;

mod ast;
mod context;
mod transpiler;

use crate::transpiler::Transpiler;

use env_logger::Builder;
use log::LevelFilter;

const TEST_C_FILE: &str = "test.c";

fn main() {
    let mut builder = Builder::from_default_env();

    builder.filter(None, LevelFilter::Info).init();

    let config = Config::default();

    let parsed_ast = lang_c::driver::parse(&config, TEST_C_FILE).unwrap();

    //println!("{:#?}", parsed_ast);

    let mut transpiler = Transpiler::new();
    transpiler.transpile_translation_unit(&parsed_ast.unit);

    println!("{}", ast::Stmts(transpiler.stmts));
}
