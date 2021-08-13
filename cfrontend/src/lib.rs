#![feature(box_patterns)]
#![feature(box_syntax)]

/// Cfrontend is the C-lang frontend transpiler for Ownership semantic language (OSL).
/// The difference between transpiler and compiler is in the level of abstraction in the output.
/// Generally, a compiler produces machine executable code; whereas transpiler produces another developer artifact.
///
/// So this transpiler is a compiler like program, which convert C-lang code to OSL code so that it can run in [Kframework](https://kframework.org/).
/// When the transpiler sees an C expression that needs to be translated, it produces a logically equivalent expression.
/// For example:
///```c
///    const int a = 10;
///    const int * b;
///    b = &a;
///```
/// is translated into
///```c
///    decl a;
///    transfer newResource(copy) a; // a = 10
///    decl b;
///    b mborrow a;
///```
use lang_c::driver::Parse;

pub mod ast;
pub mod configuration;
mod transpiler;

/// Transpile a C program file parsed by lang_c driver.
/// This function is the entry-point of this library.
/// Other binary should call this function after parsed the
/// C program.
pub fn transpile_c_program(parse: Parse, config: configuration::Configuration) -> ast::Stmts {
    let mut transpiler = transpiler::Transpiler::new(parse.source, config);
    transpiler.transpile_translation_unit(&parse.unit);
    ast::Stmts(transpiler.stmts)
}
