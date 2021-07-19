#![feature(box_patterns)]
#![feature(box_syntax)]

#[macro_use]
extern crate log;

use env_logger::Builder;
use lang_c::driver::Config;
use log::LevelFilter;

use osl::ast;
use osl::transpiler::Transpiler;

const TEST_C_FILE: &str = "test.c";

fn main() {
    let mut builder = Builder::from_default_env();

    builder.filter(None, LevelFilter::Info).init();

    let config = Config::default();

    let parsed_ast = lang_c::driver::parse(&config, TEST_C_FILE).unwrap();

    //println!("{:#?}", parsed_ast);

    let mut transpiler = Transpiler::new(TEST_C_FILE, parsed_ast.source);
    transpiler.transpile_translation_unit(&parsed_ast.unit);

    println!("{}", ast::Stmts(transpiler.stmts));
}
