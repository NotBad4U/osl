#![feature(box_patterns)]
#![feature(box_syntax)]

#[macro_use]
extern crate log;

use cfrontend::configuration::Configuration;
use env_logger::Builder;
use lang_c::driver::Config;
use log::LevelFilter;

const TEST_C_FILE: &str = "test.c";

fn main() {
    let mut builder = Builder::from_default_env();
    builder.filter(None, LevelFilter::Info).init();

    info!("parsing {}...", TEST_C_FILE);

    match lang_c::driver::parse(&Config::default(), TEST_C_FILE) {
        Ok(ast) => {
            info!("transpiling {}...", TEST_C_FILE);
            let stmts = cfrontend::transpile_c_program(ast, Configuration::new(true));
            println!("{}", cfrontend::ast::render::render_program(stmts));
        }
        Err(e) => eprintln!("{}", e),
    }
}
