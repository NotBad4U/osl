/// This module contains the definition of some std C functions like printf, malloc, etc.
/// For now, OSL can't deal with this kind of function from libc. They are to complex (inline assembly in it).
/// To counter this problem, the transpiler will just add this function with an empty body.
/// With that OSL can still verify ownership properties of the user program, but we will not verify
/// the ownership properties for the function of stdlib, stdio, libc, etc.
use super::*;

use enum_extract::let_extract;
use std::collections::HashMap;

macro_rules! hashmap {
    (@single $($x:tt)*) => (());
    (@count $($rest:expr),*) => (<[()]>::len(&[$(hashmap!(@single $rest)),*]));

    ($($key:expr => $value:expr,)+) => { hashmap!($($key => $value),+) };
    ($($key:expr => $value:expr),*) => {
        {
            let _cap = hashmap!(@count $($key),*);
            let mut _map = ::std::collections::HashMap::with_capacity(_cap);
            $(
                let _ = _map.insert($key, $value);
            )*
            _map
        }
    };
}

pub enum StdlibFunction2 {
    Printf,
    Ffprintf,
    Free,
    Malloc,
    Realloc,
    Calloc,
    Scanf,
}

/// For now, this enum doesn't provide
/// an exhaustive list of std C functions.
/// Functions will be adds throughout the life
/// cycle of this project.
#[derive(Debug)]
pub struct StdlibFunction(HashMap<String, Stmt>);

const GENERATED_FUNCTION_COMMENT: &'static str = "Auto-generated intrinsic function";

impl StdlibFunction {
    pub fn new() -> Self {
        Self(hashmap![
            // int printf(const char *format, ...)
            "printf".into() => Stmt::Function("printf".into(), Parameters(vec![
                Parameter::new("format", Type::own()),
                Parameter::new("x", Type::ref_from("a", Type::own()))]),
                Type::VoidTy,
                Stmts::from(Stmt::Comment(GENERATED_FUNCTION_COMMENT.to_string()))
            ),

            // int fprintf(FILE *stream, const char *format, ...)
            "fprintf".into() => Stmt::Function("fprintf".into(), Parameters(vec![
                Parameter::new("stream", Type::ref_from("a", Type::own_from(Props::from(vec![Prop::Mut, Prop::Copy])))),
                Parameter::new("format", Type::own()),
                Parameter::new("x", Type::ref_from("b", Type::own()))]),
                Type::VoidTy,
                Stmts::from(Stmt::Comment(GENERATED_FUNCTION_COMMENT.to_string()))
            ),

            // void free(void *ptr)
            "free".into() => Stmt::Function("free".into(), Parameters::new(), Type::VoidTy, Stmts::new()),

            // void *malloc(size_t size)
            "malloc".into() => Stmt::Function("malloc".into(), Parameters::new(), Type::Own(Props::from(Prop::Copy)), Stmts::new()),

            // void *realloc(void *ptr, size_t size)
            "realloc".into() => Stmt::Function("realloc".into(), Parameters::new(), Type::Own(Props::from(Prop::Copy)), Stmts::new()),

            // void *calloc(size_t nitems, size_t size)
            "calloc".into() => Stmt::Function("calloc".into(), Parameters::new(), Type::Own(Props::from(Prop::Copy)), Stmts::new()),

            // int scanf(const char *format, ...)
            "scanf".into() => Stmt::Function("scanf".into(),
                Parameters(vec![
                    Parameter::new("format", Type::own()),
                    Parameter::new("x", Type::ref_from("a", Type::own_from(Props::from(Prop::Mut)))),
                ]),
                Type::VoidTy,
                Stmts::from(Stmt::Comment(GENERATED_FUNCTION_COMMENT.to_string()))
            ),
        ])
    }

    pub fn is_std_function(&self, key: &str) -> bool {
        self.0.get(key).is_some()
    }

    pub fn get_std_function(&self, key: &str) -> Option<&Stmt> {
        self.0.get(key)
    }

    pub fn get_std_functions(&self) -> Vec<&Stmt> {
        self.0
            .iter()
            .filter(|(k, _)| *k != "malloc" && *k != "realloc" && *k != "calloc" && *k != "free") // this functions have specifier behavior in OSL
            .fold(vec![], |mut acc, (_, f)| {
                acc.push(f);
                acc
            })
    }
}

impl Transpiler {
    pub fn transpile_std_function(&mut self, func_name: &str, call_exp: &CallExpression) -> Stmts {
        if utils::is_deallocate_memory_function(func_name) {
            let argument_to_free = call_exp.arguments.first().unwrap();
            let identifier = match argument_to_free.node {
                Expression::Identifier(box Node {
                    node: Identifier { ref name },
                    ..
                }) => name,
                _ => unimplemented!(),
            };

            return Stmts::from(Stmt::Deallocate(Exp::Id(identifier.to_string())));
        }

        let arguments = call_exp
            .arguments
            .iter()
            .fold(Vec::new(), |mut acc, argument| {
                //FIXME: support also calling function in argument
                if let Some(Stmt::Expression(Exp::Id(id))) =
                    self.transpile_expression(&argument.node).last()
                {
                    acc.push(Exp::Id(id.to_string()));
                }

                acc
            });

        Stmts::from(Stmt::Expression(Exp::Call(
            func_name.to_string(),
            Exps(arguments),
        )))
    }
}
