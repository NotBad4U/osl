use lang_c::ast::*;
use lang_c::span::Node;

use crate::ast::*;
use crate::transpiler::context::Mutability;

pub fn convert_mutability_to_type(mutability: &Mutability) -> Type {
    match mutability {
        Mutability::ImmOwner => Type::Own(Props(vec![])),
        Mutability::MutOwner => Type::Own(Props(vec![Prop::Mut])),
        _ => unimplemented!(),
    }
}

// FIXME: support multiple init declarator
pub fn get_mutability_of_declaration(declaration: &Declaration) -> Mutability {
    let specifiers = &declaration.specifiers;
    let declarator = &declaration
        .declarators
        .first()
        .unwrap()
        .node
        .declarator
        .node;

    if is_a_ref(declarator) {
        if is_const(specifiers) {
            Mutability::ImmRef
        } else {
            Mutability::MutRef
        }
    } else {
        if is_const(specifiers) {
            Mutability::ImmOwner
        } else {
            Mutability::MutOwner
        }
    }
}

pub fn get_function_parameters_from_declarator(
    declaration: &Declarator,
) -> Vec<ParameterDeclaration> {
    match &declaration.derived.first().unwrap().node {
        DerivedDeclarator::Function(Node {
            node: FunctionDeclarator { parameters, .. },
            ..
        }) => parameters
            .into_iter()
            .map(|param| param.node.clone())
            .collect(),
        _ => vec![],
    }
}

/// extract the mutability value from a C function definition
pub fn get_return_fun_mutability_from_fun_def(function_def: &FunctionDefinition) -> Mutability {
    let specifiers = &function_def.specifiers.as_slice();
    let declarator = &function_def.declarator.node;

    if is_a_ref(declarator) {
        if is_a_ref_const(declarator) {
            Mutability::ImmRef
        } else {
            Mutability::MutRef
        }
    } else {
        if is_const(specifiers) {
            Mutability::ImmOwner
        } else {
            Mutability::MutOwner
        }
    }
}

pub fn is_a_function(declarator: &Declarator) -> bool {
    declarator
        .derived
        .as_slice()
        .iter()
        .find(|devired_declarator| {
            matches!(devired_declarator.node, DerivedDeclarator::Function(_))
        })
        .is_some()
}

/// Check if the type begin with const type qualifier
/// e.g.: const T *
pub fn is_const(specifiers: &[Node<DeclarationSpecifier>]) -> bool {
    matches!(
        specifiers,
        [
            Node {
                node: DeclarationSpecifier::TypeQualifier(Node {
                    node: TypeQualifier::Const,
                    ..
                }),
                ..
            },
            ..
        ]
    )
}

/// Check if it is a pointer
/// e.g.: T *
pub fn is_a_ref(declarator: &Declarator) -> bool {
    matches!(
        declarator.derived.as_slice(),
        [
            Node {
                node: DerivedDeclarator::Pointer(_),
                ..
            },
            ..
        ]
    )
}

/// Check if the pointer is immutable
/// e.g.: T * const
pub fn is_a_ref_const(declarator: &Declarator) -> bool {
    matches!(
        declarator.derived.as_slice(),
        [Node {
            node: DerivedDeclarator::Pointer(p),
            ..
        },
         ..
        ]
            if matches!(p.as_slice(), [
                    Node{ node: PointerQualifier::TypeQualifier(Node{ node: TypeQualifier::Const, .. }), .. },
                    ..
                ]
            )
    )
}

pub fn get_declarator_id(decl: &Declarator) -> Option<String> {
    match &decl.kind.node {
        DeclaratorKind::Identifier(Node {
            node: Identifier { ref name },
            ..
        }) => Some(name.to_string()),
        DeclaratorKind::Declarator(box Node { node, .. }) => get_declarator_id(node),
        _ => None,
    }
}

pub fn is_typedef_declaration(declaration: &Declaration) -> bool {
    match declaration.specifiers.as_slice() {
        [Node {
            node:
                DeclarationSpecifier::StorageClass(Node {
                    node: StorageClassSpecifier::Typedef,
                    ..
                }),
            ..
        }, ..] => true,
        _ => false,
    }
}

pub fn is_copyable(declaration: &Declaration) -> bool {
    let init_declarator = &declaration.declarators.first().unwrap().node;

    // Derived declarator contains the information about if it's a declaration
    // for an array, pointer and function. This type are not copyable.
    // So it should be enough to just look if the derived declarator list is empty.
    init_declarator.declarator.node.derived.is_empty()
}

pub const LIFETIME_STR_CHARSET: &[u8] = b"abcdefghijklmnopqrstuvwxyz";

pub fn generate_lifetime(i: usize) -> String {
    String::from_utf8(Vec::from([*LIFETIME_STR_CHARSET.get(i % 26).unwrap()])).expect("cannot generate a lifetime")
}

#[cfg(test)]
mod test_osl_transpile {
    use super::*;
    use enum_extract::extract;
    use lang_c::driver::parse_preprocessed;
    use lang_c::driver::Config;

    #[test]
    fn it_should_find_a_copyable_type() {
        let config = Config::default();

        let source = r#"
        int a[1];
        int *b;
        int c;
        "#
        .to_string();

        let parsed = parse_preprocessed(&config, source).expect("C test code is broken");

        // test: int a[1]
        match &parsed.unit.0.get(0).unwrap().node {
            ExternalDeclaration::Declaration(d) => assert!(is_copyable(&d.node) == false),
            _ => panic!("Should be a declaration but we got something else"),
        }

        // test: int *a;
        match &parsed.unit.0.get(1).unwrap().node {
            ExternalDeclaration::Declaration(d) => assert!(is_copyable(&d.node) == false),
            _ => panic!("Should be a declaration but we got something else"),
        }

        // test: int a;
        match &parsed.unit.0.get(2).unwrap().node {
            ExternalDeclaration::Declaration(d) => assert!(is_copyable(&d.node) == true),
            _ => panic!("Should be a declaration but we got something else"),
        }
    }

    #[test]
    fn it_should_find_a_const_return() {
        let config = Config::default();

        let source = r#"
        const int main() {
            return 0;
        }
        "#
        .to_string();

        let parsed = parse_preprocessed(&config, source).expect("C test code is broken");

        let function = &parsed
            .unit
            .0
            .first()
            .expect("the parser cannot find the main method")
            .node;

        match function {
            ExternalDeclaration::FunctionDefinition(ref f) => {
                assert_eq!(true, is_const(f.node.specifiers.as_slice()));
                assert_eq!(false, is_a_ref(&f.node.declarator.node));
            }
            _ => panic!("expected a function"),
        }
    }

    #[test]
    fn it_should_find_a_ref_to_const_return() {
        let config = Config::default();

        let source = r#"
        const int * main() {
            return 0;
        }
        "#
        .to_string();

        let parsed = parse_preprocessed(&config, source).expect("C test code is broken");

        let function = &parsed
            .unit
            .0
            .first()
            .expect("the parser cannot find the main method")
            .node;

        match function {
            ExternalDeclaration::FunctionDefinition(ref f) => {
                assert_eq!(true, is_const(f.node.specifiers.as_slice()));
                assert_eq!(true, is_a_ref(&f.node.declarator.node));
                assert_eq!(false, is_a_ref_const(&f.node.declarator.node));
            }
            _ => panic!("expected a function"),
        }
    }

    #[test]
    fn it_should_not_find_a_const_return() {
        let config = Config::default();

        let source = r#"
        int main() {
            return 0;
        }
        "#
        .to_string();

        let parsed = parse_preprocessed(&config, source).expect("C test code is broken");

        let function = &parsed
            .unit
            .0
            .first()
            .expect("the parser cannot find the main method")
            .node;

        match function {
            ExternalDeclaration::FunctionDefinition(ref f) => {
                assert_eq!(false, is_const(f.node.specifiers.as_slice()));
                assert_eq!(false, is_a_ref(&f.node.declarator.node));
            }
            _ => panic!("expected a function"),
        }
    }

    #[test]
    fn it_should_not_find_a_const_ref_to_a_const_return() {
        let config = Config::default();

        let source = r#"
        const int * const main() {
            return 0;
        }
        "#
        .to_string();

        let parsed = parse_preprocessed(&config, source).expect("C test code is broken");

        let function = &parsed
            .unit
            .0
            .first()
            .expect("the parser cannot find the main method")
            .node;

        match function {
            ExternalDeclaration::FunctionDefinition(ref f) => {
                assert_eq!(true, is_const(f.node.specifiers.as_slice()));
                assert_eq!(true, is_a_ref(&f.node.declarator.node));
                assert_eq!(true, is_a_ref_const(&f.node.declarator.node));
            }
            _ => panic!("expected a function"),
        }
    }

    #[test]
    fn it_should_find_a_typedef_declaration() {
        let config = Config::default();

        let source = r#"
        typedef unsigned long int __fsfilcnt_t;
        "#
        .to_string();

        let parsed = parse_preprocessed(&config, source).expect("C test code is broken");

        let declaration = &parsed
            .unit
            .0
            .first()
            .expect("the parser cannot find the main method")
            .node;

        let typdef_declaration = extract!(ExternalDeclaration::Declaration(_), declaration)
            .expect("no typedef in the source code, please verify the validity of the test");

        assert!(is_typedef_declaration(&typdef_declaration.node))
    }
}
