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
use std::collections::HashSet;

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
pub struct StdlibFunction(HashMap<String, Stmt>, HashSet<String>);

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
        let mut set_functions_need_arity = HashSet::new();
        set_functions_need_arity.insert("fprintf".into());
        set_functions_need_arity.insert("scanf".into());
        set_functions_need_arity.insert("printf".into());
        set_functions_need_arity.insert("pow".into());
        set_functions_need_arity.insert("fmod".into());


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
            "atol".into() => Stmt::Function("atol".into(), Parameters::from(
                Parameter::new("ptr", Type::Ref("a".into(), box Type::Own(Props::new())))
            ), Type::Own(Props::from(Prop::Copy)), Stmts::from(Stmt::Val(Exp::NewResource(Props(vec![Prop::Copy, Prop::Mut]))))),

            //FIXME: The name in hash should be pow instead of pow2
            "pow2".into() => Stmt::Function("pow".into(), Parameters(vec![
                Parameter::new("powx", Type::Own(Props(vec![Prop::Copy, Prop::Mut]))),
                Parameter::new("powy", Type::Own(Props(vec![Prop::Copy, Prop::Mut]))),
            ]), Type::Own(Props::get_all_props()), Stmts::from(Stmt::Val(Exp::NewResource(Props(vec![Prop::Copy, Prop::Mut]))))),

            //FIXME: The name in hash should be fmod instead of fmod2
            "fmod2".into() => Stmt::Function("fmod".into(), Parameters(vec![
                Parameter::new("fmodx", Type::Own(Props(vec![Prop::Copy, Prop::Mut]))),
                Parameter::new("fmody", Type::Own(Props(vec![Prop::Copy, Prop::Mut]))),
            ]), Type::Own(Props::get_all_props()), Stmts::from(Stmt::Val(Exp::NewResource(Props(vec![Prop::Copy, Prop::Mut]))))),

            "memset".into() => Stmt::Function("memset".into(), Parameters(vec![
                Parameter::new("__s", Type::Ref("a".into(), box Type::Own(Props::from(Prop::Mut)))),
                Parameter::new("__c", Type::own()),
                Parameter::new("__n", Type::Own(Props(vec![Prop::Copy, Prop::Mut]))),

            ]), Type::VoidTy, Stmts(vec![
                Stmt::Expression(Exp::Read(box Exp::Id("__n".into()))),
                Stmt::Transfer(Exp::Id("__c".into()), Exp::Id("__s".into())),
            ])),

            "socket".into() => Stmt::Function("socket".into(), Parameters(vec![
                Parameter::new("__domain", Type::Own(Props(vec![Prop::Copy, Prop::Mut]))),
                Parameter::new("__type", Type::Own(Props(vec![Prop::Copy, Prop::Mut]))),
                Parameter::new("__protocol", Type::Own(Props(vec![Prop::Copy, Prop::Mut]))),

            ]), Type::Own(Props::get_all_props()), Stmts(vec![
                Stmt::Expression(Exp::Read(box Exp::Id("__domain".into()))),
                Stmt::Expression(Exp::Read(box Exp::Id("__type".into()))),
                Stmt::Expression(Exp::Read(box Exp::Id("__protocol".into()))),
                Stmt::Val(Exp::NewResource(Props(vec![ Prop::Mut, Prop::Copy])))
            ])),

            "perror".into() => Stmt::Function("perror".into(), Parameters(vec![
                Parameter::new("__s", Type::own()),

            ]), Type::VoidTy, Stmts(vec![
                Stmt::Expression(Exp::Read(box Exp::Id("__s".into()))),
            ])),

            "exit".into() => Stmt::Function("exit".into(), Parameters(vec![
                Parameter::new("status", Type::Own(Props(vec![ Prop::Mut, Prop::Copy]))),

            ]), Type::VoidTy, Stmts(vec![
                Stmt::Expression(Exp::Read(box Exp::Id("status".into()))),
            ])),

            "htons".into() => Stmt::Function("htons".into(), Parameters(vec![
                Parameter::new("__hostlong", Type::Own(Props(vec![Prop::Copy, Prop::Mut]))),

            ]), Type::Own(Props::get_all_props()), Stmts(vec![
                Stmt::Expression(Exp::Read(box Exp::Id("__hostlong".into()))),
                Stmt::Val(Exp::NewResource(Props(vec![ Prop::Mut, Prop::Copy])))
            ])),

            "bind".into() => Stmt::Function("bind".into(), Parameters(vec![
                Parameter::new("__sockfd", Type::Own(Props(vec![Prop::Copy, Prop::Mut]))),
                Parameter::new("__addr", Type::Own(Props(vec![Prop::Copy, Prop::Mut]))),
                Parameter::new("__addrlen", Type::Own(Props(vec![Prop::Copy, Prop::Mut]))),
            ]), Type::VoidTy, Stmts(vec![
                Stmt::Expression(Exp::Read(box Exp::Id("__sockfd".into()))),
                Stmt::Expression(Exp::Read(box Exp::Id("__addr".into()))),
                Stmt::Expression(Exp::Read(box Exp::Id("__addrlen".into()))),
            ])),

            "accept".into() => Stmt::Function("accept".into(), Parameters(vec![
                Parameter::new("__sockfd", Type::Own(Props(vec![Prop::Copy, Prop::Mut]))),
                Parameter::new("__addr", Type::Ref("a".into(), box Type::Own(Props::new()))),
                Parameter::new("__addrlen", Type::Ref("b".into(), box Type::Own(Props::new()))),
            ]), Type::own_from(Props::get_all_props()), Stmts(vec![
                Stmt::Expression(Exp::Read(box Exp::Id("__sockfd".into()))),
                Stmt::Expression(Exp::Read(box Exp::Id("__addr".into()))),
                Stmt::Expression(Exp::Read(box Exp::Id("__addrlen".into()))),
                Stmt::Val(Exp::NewResource(Props::get_all_props()))
            ])),

            "close".into() => Stmt::Function("close".into(), Parameters(vec![
                Parameter::new("__fd", Type::Own(Props(vec![ Prop::Mut, Prop::Copy]))),

            ]), Type::VoidTy, Stmts(vec![
                Stmt::Expression(Exp::Read(box Exp::Id("__fd".into()))),
            ])),


            // int listen(int sockfd, int backlog);
            "listen".into() => Stmt::Function("listen".into(), Parameters(vec![
                Parameter::new("__sockfd", Type::Own(Props(vec![ Prop::Mut, Prop::Copy]))),
                Parameter::new("__backlog", Type::Own(Props(vec![ Prop::Mut, Prop::Copy]))),
            ]), Type::VoidTy, Stmts(vec![
                Stmt::Expression(Exp::Read(box Exp::Id("__sockfd".into()))),
                Stmt::Expression(Exp::Read(box Exp::Id("__backlog".into()))),
            ])),

            // extern ssize_t write (int __fd, const void *__buf, size_t __n) __wur;
            "write".into() => Stmt::Function("write".into(), Parameters(vec![
                Parameter::new("__fd", Type::Own(Props(vec![ Prop::Mut, Prop::Copy]))),
                Parameter::new("__buf", Type::Ref("a".into(), box Type::Own(Props::new()))),
                Parameter::new("__n", Type::Own(Props(vec![ Prop::Mut, Prop::Copy]))),
            ]), Type::Own(Props::get_all_props()), Stmts(vec![
                Stmt::Expression(Exp::Read(box Exp::Id("__fd".into()))),
                Stmt::Expression(Exp::Read(box Exp::Id("__buf".into()))),
                Stmt::Expression(Exp::Read(box Exp::Id("__n".into()))),
                Stmt::Val(Exp::NewResource(Props::get_all_props()))
            ])),

            // size_t strlen(const char *s);
            "strlen".into() => Stmt::Function("strlen".into(), Parameters(vec![
                Parameter::new("__s", Type::Own(Props::new())),

            ]), Type::Own(Props::get_all_props()), Stmts(vec![
                Stmt::Expression(Exp::Read(box Exp::Id("__s".into()))),
                Stmt::Val(Exp::NewResource(Props(vec![ Prop::Mut, Prop::Copy])))
            ])),
        ],
            set_functions_need_arity,
        )
    }

    pub fn is_std_function(&self, key: &str) -> bool {
        self.1.contains(key)
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
