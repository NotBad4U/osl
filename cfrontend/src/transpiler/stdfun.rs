/// This module contains the definition of some std C functions like printf, malloc, etc.
/// For now, OSL can't deal with this kind of function from libc. They are to complex (inline assembly in it).
/// To counter this problem, the transpiler will just add this function with an empty body.
/// With that OSL can still verify ownership properties of the user program, but we will not verify
/// the ownership properties for the function of stdlib, stdio, libc, etc.
use super::*;

use std::cmp::Ordering;
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

/// For now, this enum doesn't provide
/// an exhaustive list of std C functions.
/// Functions will be adds throughout the life
/// cycle of this project.
#[derive(Debug)]
pub struct StdlibFunction(HashMap<String, Stmt>);

const GENERATED_FUNCTION_COMMENT: &'static str = "transpiler built-in";

macro_rules! count {
    () => (0usize);
    ( $x:tt $($xs:tt)* ) => (1usize + count!($($xs)*));
}

macro_rules! printf {
    ( $( $args:expr ),* ) => {
        Stmt::Function(format!("printf{}", count!($($args)*)), Parameters(vec![
                Parameter::new("format", Type::own()),
                $( Parameter::new($args, Type::ref_from($args, Type::own())) , )*
            ]),
            Type::VoidTy,
            Stmts::from(Stmt::Comment(GENERATED_FUNCTION_COMMENT.to_string()))
        )
    };
}

macro_rules! fprintf {
    ( $( $args:expr ),* ) => {
        Stmt::Function(
            format!("fprintf{}", count!($($args)*)),
            Parameters(vec![
                Parameter::new(
                    "stream",
                    Type::ref_from(
                        "a",
                        Type::own_from(Props::from(vec![Prop::Mut, Prop::Copy])),
                    ),
                ),
                Parameter::new("format", Type::own()),
                Parameter::new("x", Type::ref_from("b", Type::own())),
            ]),
            Type::VoidTy,
            Stmts::from(Stmt::Comment(GENERATED_FUNCTION_COMMENT.to_string())),
        )
    };
}

macro_rules! scanf {
    ( $( $args:expr ),* ) => {
        Stmt::Function(
            format!("scanf{}", count!($($args)*)),
            Parameters(vec![
                Parameter::new("format", Type::own()),
                $( Parameter::new($args, Type::ref_from($args, Type::own_from(Props::from(Prop::Mut)))), )*
            ]),
            Type::VoidTy,
            Stmts::from(Stmt::Comment(GENERATED_FUNCTION_COMMENT.to_string())),
        )
    };
}

impl StdlibFunction {
    pub fn new() -> Self {
        Self(hashmap![
            // int printf(const char *format, ...)
            "printf".into() => printf!("a"),
            "printf2".into() => printf!("a", "b"),
            "printf3".into() => printf!("a", "b", "c"),
            "printf4".into() => printf!("a", "b", "c", "d"),
            "printf5".into() => printf!("a", "b", "c", "d", "e"),

            // int fprintf(FILE *stream, const char *format, ...)
            "fprintf".into() => fprintf!("a"),
            "fprintf2".into() => fprintf!("a", "b"),
            "fprintf3".into() => fprintf!("a", "b", "c"),
            "fprintf4".into() => fprintf!("a", "b", "c", "d"),
            "fprintf5".into() => fprintf!("a", "b", "c", "d", "e"),

            // int scanf(const char *format, ...)
            "scanf".into() => scanf!("a"),
            "scanf2".into() => scanf!("a", "b"),
            "scanf3".into() => scanf!("a", "b", "c"),
            "scanf4".into() => scanf!("a", "b", "c", "d"),
            "scanf5".into() => scanf!("a", "b", "c", "d", "e"),

            // void free(void *ptr)
            "free".into() => Stmt::Function("free".into(), Parameters::new(), Type::VoidTy, Stmts::new()),

            // void *malloc(size_t size)
            "malloc".into() => Stmt::Function("malloc".into(), Parameters::new(), Type::Own(Props::from(Prop::Copy)), Stmts::new()),

            // void *realloc(void *ptr, size_t size)
            "realloc".into() => Stmt::Function("realloc".into(), Parameters::new(), Type::Own(Props::from(Prop::Copy)), Stmts::new()),

            // void *calloc(size_t nitems, size_t size)
            "calloc".into() => Stmt::Function("calloc".into(), Parameters::new(), Type::Own(Props::from(Prop::Copy)), Stmts::new()),
        ])
    }

    pub fn is_std_function(&self, key: &str) -> bool {
        self.0.get(key).is_some()
    }

    pub fn get_std_functions(&self) -> Vec<&Stmt> {
        let mut stmts = self
            .0
            .iter()
            .filter(|(k, _)| *k != "malloc" && *k != "realloc" && *k != "calloc" && *k != "free") // this functions have specifier behavior in OSL
            .fold(vec![], |mut acc, (_, f)| {
                acc.push(f);
                acc
            });

        stmts.sort_by(|a, b| match (a, b) {
            (Stmt::Function(id_a, ..), Stmt::Function(id_b, ..)) => id_a.cmp(id_b),
            _ => Ordering::Equal,
        });

        stmts
    }
}
