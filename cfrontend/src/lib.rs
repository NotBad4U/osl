#![feature(box_patterns)]
#![feature(box_syntax)]

pub mod ast;
pub mod transpiler;

use lang_c::driver::Parse;

pub fn transpile_c_program(source: Parse) -> ast::Stmts {
    let mut transpiler = transpiler::Transpiler::new();
    transpiler.transpile_translation_unit(&source.unit);
    ast::Stmts(transpiler.stmts)
}
