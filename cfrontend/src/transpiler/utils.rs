use lang_c::ast::*;
use lang_c::span::Node;

use crate::ast::*;
use crate::transpiler::context::Mutability;

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
    match &declaration.derived.last().unwrap().node {
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
pub fn get_return_fun_mutability_from_fun_def(
    function_def: &FunctionDefinition,
) -> Option<Mutability> {
    let specifiers = &function_def.specifiers.as_slice();
    let declarator = &function_def.declarator.node;

    if is_a_ref(declarator) {
        if is_a_ref_const(declarator) {
            Some(Mutability::ImmRef)
        } else {
            Some(Mutability::MutRef)
        }
    } else {
        if is_void(specifiers) {
            return None;
        }

        if is_const(specifiers) {
            Some(Mutability::ImmOwner)
        } else {
            Some(Mutability::MutOwner)
        }
    }
}

/// Check if the type specifier is void
pub fn is_void(specifiers: &[Node<DeclarationSpecifier>]) -> bool {
    matches!(
        specifiers,
        [Node {
            node: DeclarationSpecifier::TypeSpecifier(Node {
                node: TypeSpecifier::Void,
                ..
            }),
            ..
        },]
    )
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

pub fn get_props_from_declaration(declaration: &Declaration) -> Props {
    let decl_mut = get_mutability_of_declaration(declaration);

    // construct the props by looking at the types
    let mut props = Props::new();
    if is_copyable(declaration) {
        props.0.push(Prop::Copy);
    }

    if let Mutability::MutOwner = decl_mut {
        props.0.push(Prop::Mut);
    }

    props
}

pub const LIFETIME_STR_CHARSET: &[u8] = b"abcdefghijklmnopqrstuvwxyz";

pub fn generate_lifetime(i: usize) -> String {
    String::from_utf8(Vec::from([*LIFETIME_STR_CHARSET.get(i % 26).unwrap()]))
        .expect("cannot generate a lifetime")
}

#[inline]
pub fn is_allocate_memory_function(func: &str) -> bool {
    func == "malloc" || func == "realloc" || func == "calloc"
}

#[inline]
pub fn is_deallocate_memory_function(func: &str) -> bool {
    func == "free"
}

pub fn get_props_from_declarator(declarator: &Option<Node<Declarator>>) -> Props {
    let mut props = Props(vec![]);

    if let None = declarator {
        props.0.push(Prop::Copy)
    }

    props
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

    #[test]
    fn it_should_get_props_from_declaration() {
        let config = Config::default();

        let source = r#"
        int a;
        const int b;
        "#
        .to_string();

        let parsed = parse_preprocessed(&config, source).expect("C test code is broken");

        let declaration_a = &parsed
            .unit
            .0
            .first()
            .expect("cannot find the declaration of variable a")
            .node;

        let declaration_b = &parsed
            .unit
            .0
            .get(1)
            .expect("cannot find the declaration of variable b")
            .node;

        let declaration_a = extract!(ExternalDeclaration::Declaration(_), declaration_a).expect(
            "no declaration of 'a' in the source code, please verify the validity of the test",
        );

        let declaration_b = extract!(ExternalDeclaration::Declaration(_), declaration_b).expect(
            "no declaration of 'b' in the source code, please verify the validity of the test",
        );

        assert_eq!(
            Props(vec![Prop::Copy, Prop::Mut]),
            get_props_from_declaration(&declaration_a.node)
        );
        assert_eq!(
            Props(vec![Prop::Copy]),
            get_props_from_declaration(&declaration_b.node)
        );
    }
}
