#![feature(box_patterns)]
#![feature(box_syntax)]

use lang_c::driver::Parse;

pub mod ast;
mod transpiler;

pub fn transpile_c_program(parse: Parse) -> ast::Stmts {
    let mut transpiler = transpiler::Transpiler::new(parse.source);
    transpiler.transpile_translation_unit(&parse.unit);
    ast::Stmts(transpiler.stmts)
}
