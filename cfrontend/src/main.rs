#[macro_use] extern crate log;

use lang_c::driver::Config;

mod context;
mod osl;

use crate::osl::Transformer;

fn main() {
    env_logger::init();

    let config = Config::default();

    let parsed_ast = lang_c::driver::parse(&config, "test.c").unwrap();

    let mut transpiler = Transformer::new();
    transpiler.transform_translation_unit(&parsed_ast.unit);

    info!("{}", osl::Stmts(transpiler.stmts));
}
