/// This module contains the definition of some std C functions like printf, malloc, etc.
/// For now, OSL can't deal with this kind of function from libc. They are to complex (inline assembly in it).
/// To counter this problem, the transpiler will just add this function with an empty body.
/// With that OSL can still verify ownership properties of the user program, but we will not verify
/// the ownership properties for the function of stdlib, stdio, libc, etc.
///
/// Some function like printf use the variadic arguments feature.
/// Currently, OSL can't deal with variadic arguments, so we generate
/// a function for each n-th different arity possible. For example, printf become:
///
/// For arity 1 (just the format):
/// `fn printf1(format:#own()) -> #voidTy`
/// For arity 2 (format and one argument):
/// `fn printf2(format:#own(),_a:#ref('a,#own())) -> #voidTy`
/// For arity 3:
/// fn printf3(format:#own(),_a:#ref('a,#own()),_b:#ref('b,#own())) -> #voidTy`
/// etc...
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

fn uncollision_param(param: &str) -> String {
    format!("_{}", param)
}

/// For now, this enum doesn't provide
/// an exhaustive list of std C functions.
/// Functions will be adds throughout the life
/// cycle of this project.
#[derive(Debug)]
pub struct StdlibFunction(HashMap<String, Stmt>);

const GENERATED_FUNCTION_COMMENT: &'static str = "transpiler built-in";

/// Used to generate the correct postfix
/// of variadic function:  fun<N>, where
/// N is defined by the number of arguments.
macro_rules! count {
    () => (1usize);
    ( $x:tt $($xs:tt)* ) => (1usize + count!($($xs)*));
}

// int printf(const char *format, ...)
macro_rules! printf {
    ( $( $args:expr ),* ) => {
        Stmt::Function(format!("printf{}", count!($($args)*)), Parameters(vec![
                Parameter::new("format", Type::own()),
                $( Parameter::new(&uncollision_param($args), Type::ref_from($args, Type::own())) , )*
            ]),
            Type::VoidTy,
            Stmts(vec![
                Stmt::Comment(GENERATED_FUNCTION_COMMENT.to_string()),
                $( Stmt::Expression(Exp::Read(box Exp::Id(uncollision_param($args)))), )*
            ])
        )
    };
}

// int fprintf(FILE *stream, const char *format, ...)
macro_rules! fprintf {
    ( $( $args:expr ),* ) => {
        Stmt::Function(
            format!("fprintf{}", count!($($args)*)),
            Parameters(vec![
                Parameter::new(
                    "stream",
                    Type::ref_from(
                        "s",
                        Type::own_from(Props::from(vec![Prop::Mut, Prop::Copy])),
                    ),
                ),
                Parameter::new("format", Type::own()),
                $( Parameter::new(&uncollision_param($args), Type::ref_from($args, Type::own())) , )*
            ]),
            Type::VoidTy,
            Stmts(vec![
                Stmt::Comment(GENERATED_FUNCTION_COMMENT.to_string()),
                $( Stmt::Expression(Exp::Read(box Exp::Id(uncollision_param($args)))), )*
            ])
        )
    };
}

// int scanf(const char *format, ...)
macro_rules! scanf {
    ( $( $args:expr ),* ) => {
        Stmt::Function(
            format!("scanf{}", count!($($args)*)),
            Parameters(vec![
                Parameter::new("format", Type::own()),
                $( Parameter::new(&uncollision_param($args), Type::ref_from($args, Type::own_from(Props::from(Prop::Mut)))), )*
            ]),
            Type::VoidTy,
            Stmts::from(Stmt::Comment(GENERATED_FUNCTION_COMMENT.to_string())),
        )
    };
}

impl StdlibFunction {
    pub fn new() -> Self {
        Self(hashmap![
            "printf".into() => printf!(),
            "printf2".into() => printf!("a"),
            "printf3".into() => printf!("a", "b"),
            "printf4".into() => printf!("a", "b", "c"),
            "printf5".into() => printf!("a", "b", "c", "d"),

            "fprintf".into() => fprintf!(),
            "fprintf2".into() => fprintf!("a"),
            "fprintf3".into() => fprintf!("a", "b"),
            "fprintf4".into() => fprintf!("a", "b", "c"),
            "fprintf5".into() => fprintf!("a", "b", "c", "d"),

            "scanf".into() => scanf!(),
            "scanf2".into() => scanf!("a"),
            "scanf3".into() => scanf!("a", "b"),
            "scanf4".into() => scanf!("a", "b", "c"),
            "scanf5".into() => scanf!("a", "b", "c", "d"),

            // void free(void *ptr)
            "free".into() => Stmt::Function("free".into(), Parameters::new(), Type::VoidTy, Stmts::new()),

            // void *malloc(size_t size)
            "malloc".into() => Stmt::Function("malloc".into(), Parameters(vec![
                Parameter::new("size", Type::Own(Props(vec![Prop::Copy, Prop::Mut]))),
            ]), Type::Own(Props::from(Prop::Copy)), Stmts::new()),

            // void *realloc(void *ptr, size_t size)
            "realloc".into() => Stmt::Function("realloc".into(), Parameters(vec![
                Parameter::new("ptr", Type::Ref("a".into(), box Type::Own(Props(vec![Prop::Copy, Prop::Mut])))),
                Parameter::new("size", Type::Own(Props(vec![Prop::Copy, Prop::Mut]))),
            ]), Type::Own(Props::from(Prop::Copy)), Stmts::new()),

            // void *calloc(size_t nitems, size_t size)
            "calloc".into() => Stmt::Function("calloc".into(), Parameters(vec![
                Parameter::new("nitems", Type::Own(Props(vec![Prop::Copy, Prop::Mut]))),
                Parameter::new("size", Type::Own(Props(vec![Prop::Copy, Prop::Mut]))),
            ]), Type::Own(Props::from(Prop::Copy)), Stmts::new()),

            // int abs(int x) Returns the absolute value of x.
            "abs".into() => Stmt::Function("abs".into(), Parameters(vec![
                Parameter::new("x", Type::Own(Props(vec![Prop::Copy, Prop::Mut]))),
            ]), Type::Own(Props::from(Prop::Copy)), Stmts::from(Stmt::Val(Exp::NewResource(Props(vec![Prop::Copy, Prop::Mut]))))),

            // int rand(void) Returns a pseudo-random number in the range of 0 to RAND_MAX.
            "rand".into() => Stmt::Function("rand".into(), Parameters::new(), Type::Own(Props::from(Prop::Copy)), Stmts::from(Stmt::Val(Exp::NewResource(Props(vec![Prop::Copy, Prop::Mut]))))),

            // int atoi(const char *str)
            "atoi".into() => Stmt::Function("atoi".into(), Parameters::from(
                Parameter::new("ptr", Type::Ref("a".into(), box Type::Own(Props::new())))
            ), Type::Own(Props::from(Prop::Copy)), Stmts::from(Stmt::Val(Exp::NewResource(Props(vec![Prop::Copy, Prop::Mut]))))),

            // double atof(const char *str)
            "atof".into() => Stmt::Function("atof".into(), Parameters::from(
                Parameter::new("ptr", Type::Ref("a".into(), box Type::Own(Props::new())))
            ), Type::Own(Props::from(Prop::Copy)), Stmts::from(Stmt::Val(Exp::NewResource(Props(vec![Prop::Copy, Prop::Mut]))))),

            // long int atol(const char *str)
            "atol;".into() => Stmt::Function("atol".into(), Parameters::from(
                Parameter::new("ptr", Type::Ref("a".into(), box Type::Own(Props::new())))
            ), Type::Own(Props::from(Prop::Copy)), Stmts::from(Stmt::Val(Exp::NewResource(Props(vec![Prop::Copy, Prop::Mut]))))),
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
