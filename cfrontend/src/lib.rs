#![feature(box_patterns)]
#![feature(box_syntax)]

use lang_c::driver::Parse;

pub mod ast;
pub mod configuration;
mod transpiler;

pub fn transpile_c_program(parse: Parse, config: configuration::Configuration) -> ast::Stmts {
    let mut transpiler = transpiler::Transpiler::new(parse.source, config);
    transpiler.transpile_translation_unit(&parse.unit);
    ast::Stmts(transpiler.stmts)
}
